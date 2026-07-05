import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/core/ai/prompts/prompt_manager.dart';
import 'package:discipline_os/core/ai/services/ai_orchestrator.dart';
import 'package:discipline_os/core/ai/services/gemini_service.dart';
import 'package:discipline_os/features/ai_coach/data/datasources/ai_coach_remote_datasource.dart';
import 'package:discipline_os/features/ai_coach/data/repositories/ai_coach_repository_impl.dart';
import 'package:discipline_os/features/ai_coach/domain/entities/ai_coach_conversation.dart';
import 'package:discipline_os/features/ai_coach/domain/repositories/ai_coach_repository.dart';
import 'package:discipline_os/features/ai_coach/domain/usecases/get_conversation_history.dart';
import 'package:discipline_os/features/ai_coach/domain/usecases/send_message.dart';
import 'package:discipline_os/features/ai_coach/domain/usecases/start_conversation.dart';

final geminiServiceProvider = Provider<GeminiService>((ref) {
  return GeminiService();
});

final promptManagerProvider = Provider<PromptManager>((ref) {
  return PromptManager.instance;
});

final aiOrchestratorProvider = Provider<AiOrchestrator>((ref) {
  final geminiService = ref.watch(geminiServiceProvider);
  final promptManager = ref.watch(promptManagerProvider);
  return AiOrchestrator(
    geminiService: geminiService,
    promptManager: promptManager,
  );
});

final aiCoachRemoteDataSourceProvider = Provider<AiCoachRemoteDataSource>(
  (ref) {
    final aiOrchestrator = ref.watch(aiOrchestratorProvider);
    return AiCoachRemoteDataSource(aiOrchestrator: aiOrchestrator);
  },
);

final aiCoachRepositoryProvider = Provider<AiCoachRepository>((ref) {
  final remoteDataSource = ref.watch(aiCoachRemoteDataSourceProvider);
  return AiCoachRepositoryImpl(remoteDataSource: remoteDataSource);
});

final startConversationProvider = Provider<StartConversation>((ref) {
  final repository = ref.watch(aiCoachRepositoryProvider);
  return StartConversation(repository);
});

final sendMessageProvider = Provider<SendMessage>((ref) {
  final repository = ref.watch(aiCoachRepositoryProvider);
  return SendMessage(repository);
});

final getConversationHistoryProvider = Provider<GetConversationHistory>(
  (ref) {
    final repository = ref.watch(aiCoachRepositoryProvider);
    return GetConversationHistory(repository);
  },
);

enum AiCoachState { idle, loading, loaded, error, sending }

class AiCoachDataState {
  final AiCoachState state;
  final AiCoachConversation? conversation;
  final String? error;

  const AiCoachDataState({
    this.state = AiCoachState.idle,
    this.conversation,
    this.error,
  });

  AiCoachDataState copyWith({
    AiCoachState? state,
    AiCoachConversation? conversation,
    String? error,
  }) {
    return AiCoachDataState(
      state: state ?? this.state,
      conversation: conversation ?? this.conversation,
      error: error ?? this.error,
    );
  }
}

class AiCoachNotifier extends StateNotifier<AiCoachDataState> {
  final StartConversation _startConversation;
  final SendMessage _sendMessage;
  final GetConversationHistory _getConversationHistory;

  AiCoachNotifier({
    required StartConversation startConversation,
    required SendMessage sendMessage,
    required GetConversationHistory getConversationHistory,
  })  : _startConversation = startConversation,
        _sendMessage = sendMessage,
        _getConversationHistory = getConversationHistory,
        super(const AiCoachDataState());

  Future<void> startNewConversation(String userId) async {
    state = state.copyWith(state: AiCoachState.loading);

    final result = await _startConversation(userId: userId);

    result.fold(
      (failure) => state = state.copyWith(
        state: AiCoachState.error,
        error: failure.message,
      ),
      (conversation) => state = state.copyWith(
        state: AiCoachState.loaded,
        conversation: conversation,
      ),
    );
  }

  Future<void> sendUserMessage({
    required String content,
    required String userId,
  }) async {
    if (state.conversation == null) {
      await startNewConversation(userId);
      if (state.conversation == null) return;
    }

    state = state.copyWith(state: AiCoachState.sending);

    final result = await _sendMessage(
      conversationId: state.conversation!.id,
      content: content,
    );

    result.fold(
      (failure) => state = state.copyWith(
        state: AiCoachState.error,
        error: failure.message,
      ),
      (conversation) => state = state.copyWith(
        state: AiCoachState.loaded,
        conversation: conversation,
      ),
    );
  }

  Future<void> loadConversation(String conversationId) async {
    state = state.copyWith(state: AiCoachState.loading);

    final result = await _getConversationHistory(
      conversationId: conversationId,
    );

    result.fold(
      (failure) => state = state.copyWith(
        state: AiCoachState.error,
        error: failure.message,
      ),
      (conversation) => state = state.copyWith(
        state: AiCoachState.loaded,
        conversation: conversation,
      ),
    );
  }
}

final aiCoachNotifierProvider =
    StateNotifierProvider<AiCoachNotifier, AiCoachDataState>((ref) {
  final startConversation = ref.watch(startConversationProvider);
  final sendMessage = ref.watch(sendMessageProvider);
  final getConversationHistory = ref.watch(getConversationHistoryProvider);
  return AiCoachNotifier(
    startConversation: startConversation,
    sendMessage: sendMessage,
    getConversationHistory: getConversationHistory,
  );
});
