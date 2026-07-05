import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/ai_coach/domain/entities/ai_coach_conversation.dart';

abstract class AiCoachRepository {
  Future<Either<Failure, AiCoachConversation>> startConversation({
    required String userId,
  });

  Future<Either<Failure, AiCoachConversation>> sendMessage({
    required String conversationId,
    required String content,
  });

  Future<Either<Failure, AiCoachConversation>> getConversation({
    required String conversationId,
  });

  Future<Either<Failure, List<AiCoachConversation>>> getConversations({
    required String userId,
    int? limit,
    int? offset,
  });
}
