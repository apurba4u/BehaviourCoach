import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/ai/errors/ai_exception.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/core/sync/sync_manager.dart';
import 'package:discipline_os/core/utils/logger.dart';
import 'package:discipline_os/features/ai_coach/data/datasources/ai_coach_local_datasource.dart';
import 'package:discipline_os/features/ai_coach/data/datasources/ai_coach_remote_datasource.dart';
import 'package:discipline_os/features/ai_coach/domain/entities/ai_coach_conversation.dart';
import 'package:discipline_os/features/ai_coach/domain/entities/ai_coach_message.dart';
import 'package:discipline_os/features/ai_coach/domain/repositories/ai_coach_repository.dart';
import 'package:uuid/uuid.dart';

class AiCoachRepositoryImpl implements AiCoachRepository {
  final AiCoachLocalDataSource _localDataSource;
  final AiCoachRemoteDataSource _remoteDataSource;
  final SyncManager _syncManager;

  AiCoachRepositoryImpl({
    AiCoachLocalDataSource? localDataSource,
    required AiCoachRemoteDataSource remoteDataSource,
    SyncManager? syncManager,
  })  : _localDataSource = localDataSource ?? AiCoachLocalDataSource(),
        _remoteDataSource = remoteDataSource,
        _syncManager = syncManager ?? SyncManager.instance;

  @override
  Future<Either<Failure, AiCoachConversation>> startConversation({
    required String userId,
  }) async {
    try {
      final conversationId = const Uuid().v4();
      final now = DateTime.now();

      final conversation = AiCoachConversation(
        id: conversationId,
        userId: userId,
        messages: const [],
        createdAt: now,
        updatedAt: now,
      );

      await _localDataSource.cacheConversation(conversation);

      try {
        await _remoteDataSource.createConversation(
          userId: userId,
          conversationId: conversationId,
        );
      } catch (e) {
        Logger.warning(
            'Failed to sync conversation to remote, queued for sync');
        await _syncManager.addPendingOperation(
          entityType: 'ai_coach_conversation',
          entityId: conversationId,
          operation: 'create',
          data: {
            'id': conversationId,
            'user_id': userId,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          },
        );
      }

      return Right(conversation);
    } catch (e) {
      Logger.error('Failed to start AI coach conversation', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AiCoachConversation>> sendMessage({
    required String conversationId,
    required String content,
  }) async {
    try {
      var conversation = _localDataSource.getCachedConversation(conversationId);
      if (conversation == null) {
        return const Left(ServerFailure(message: 'Conversation not found'));
      }

      final userMessageId = const Uuid().v4();
      final userMessage = AiCoachMessage(
        id: userMessageId,
        content: content,
        role: AiCoachMessageRole.user,
        timestamp: DateTime.now(),
      );

      final updatedMessages = [...conversation.messages, userMessage];
      final now = DateTime.now();
      conversation = conversation.copyWith(
        messages: updatedMessages,
        updatedAt: now,
      );
      await _localDataSource.cacheConversation(conversation);

      try {
        await _remoteDataSource.insertMessage(
          conversationId: conversationId,
          messageId: userMessageId,
          content: content,
          role: 'user',
        );
      } catch (e) {
        await _syncManager.addPendingOperation(
          entityType: 'ai_coach_message',
          entityId: userMessageId,
          operation: 'create',
          data: {
            'id': userMessageId,
            'conversation_id': conversationId,
            'content': content,
            'role': 'user',
          },
        );
      }

      final historyForAi = updatedMessages
          .map((m) => {
                'role':
                    m.role == AiCoachMessageRole.user ? 'user' : 'assistant',
                'content': m.content,
              })
          .toList();

      final assistantMessageId = const Uuid().v4();
      try {
        final aiResponse = await _remoteDataSource.generateAiResponse(
          conversationHistory: historyForAi,
        );

        final assistantMessage = AiCoachMessage(
          id: assistantMessageId,
          content: aiResponse.content,
          role: AiCoachMessageRole.assistant,
          timestamp: DateTime.now(),
        );

        updatedMessages.add(assistantMessage);
        final updatedNow = DateTime.now();
        conversation = conversation.copyWith(
          messages: updatedMessages,
          updatedAt: updatedNow,
        );
        await _localDataSource.cacheConversation(conversation);

        try {
          await _remoteDataSource.insertMessage(
            conversationId: conversationId,
            messageId: assistantMessageId,
            content: aiResponse.content,
            role: 'assistant',
          );
        } catch (e) {
          await _syncManager.addPendingOperation(
            entityType: 'ai_coach_message',
            entityId: assistantMessageId,
            operation: 'create',
            data: {
              'id': assistantMessageId,
              'conversation_id': conversationId,
              'content': aiResponse.content,
              'role': 'assistant',
            },
          );
        }
      } on AiException catch (e) {
        Logger.error('AI response generation failed', error: e);
        final errorMessage = AiCoachMessage(
          id: assistantMessageId,
          content:
              'Sorry, I encountered an issue generating a response. Please try again.',
          role: AiCoachMessageRole.assistant,
          timestamp: DateTime.now(),
        );
        updatedMessages.add(errorMessage);
        conversation = conversation!.copyWith(
          messages: updatedMessages,
          updatedAt: DateTime.now(),
        );
        await _localDataSource.cacheConversation(conversation);
      }

      return Right(conversation);
    } catch (e) {
      Logger.error('Failed to send message', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AiCoachConversation>> getConversation({
    required String conversationId,
  }) async {
    try {
      final cached = _localDataSource.getCachedConversation(conversationId);
      if (cached != null) {
        return Right(cached);
      }

      try {
        final remoteData =
            await _remoteDataSource.getConversation(conversationId);
        final messagesData =
            await _remoteDataSource.getMessages(conversationId);

        final messages = messagesData
            .map(
              (m) => AiCoachMessage(
                id: m['id'] as String,
                content: m['content'] as String,
                role: AiCoachMessageRole.values.firstWhere(
                  (r) => r.name == m['role'],
                  orElse: () => AiCoachMessageRole.user,
                ),
                timestamp: DateTime.parse(m['created_at'] as String),
              ),
            )
            .toList();

        final conversation = AiCoachConversation(
          id: remoteData['id'] as String,
          userId: remoteData['user_id'] as String,
          messages: messages,
          createdAt: DateTime.parse(remoteData['created_at'] as String),
          updatedAt: DateTime.parse(remoteData['updated_at'] as String),
        );

        await _localDataSource.cacheConversation(conversation);
        return Right(conversation);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } catch (e) {
      Logger.error('Failed to get conversation', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AiCoachConversation>>> getConversations({
    required String userId,
    int? limit,
    int? offset,
  }) async {
    try {
      var conversations = _localDataSource.getCachedConversationsByUser(userId)
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      if (limit != null) {
        conversations = conversations.take(limit).toList();
      }

      return Right(conversations);
    } catch (e) {
      Logger.error('Failed to get conversations', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
