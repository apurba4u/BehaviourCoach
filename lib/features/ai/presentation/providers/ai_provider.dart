import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/core/ai/prompts/prompt_manager.dart';
import 'package:discipline_os/core/ai/services/ai_orchestrator.dart';
import 'package:discipline_os/core/ai/services/gemini_service.dart';
import 'package:discipline_os/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:discipline_os/features/ai/domain/entities/ai_insight_entity.dart';
import 'package:discipline_os/features/ai/domain/repositories/ai_repository.dart';
import 'package:discipline_os/features/ai/domain/usecases/analyze_behavior_patterns.dart';
import 'package:discipline_os/features/ai/domain/usecases/analyze_focus_sessions.dart';
import 'package:discipline_os/features/ai/domain/usecases/analyze_goals.dart';
import 'package:discipline_os/features/ai/domain/usecases/analyze_reflections.dart';
import 'package:discipline_os/features/ai/domain/usecases/generate_daily_insight.dart';
import 'package:discipline_os/features/ai/domain/usecases/generate_recommendations.dart';
import 'package:discipline_os/features/ai/domain/usecases/generate_weekly_summary.dart';

/// Gemini Service Provider
final geminiServiceProvider = Provider<GeminiService>((ref) {
  final service = GeminiService()..initialize();
  ref.onDispose(service.dispose);
  return service;
});

/// Prompt Manager Provider
final promptManagerProvider = Provider<PromptManager>((ref) {
  return PromptManager.instance;
});

/// AI Orchestrator Provider
final aiOrchestratorProvider = Provider<AiOrchestrator>((ref) {
  final geminiService = ref.watch(geminiServiceProvider);
  final promptManager = ref.watch(promptManagerProvider);
  return AiOrchestrator(
    geminiService: geminiService,
    promptManager: promptManager,
  );
});

/// AI Repository Provider
final aiRepositoryProvider = Provider<AiRepository>((ref) {
  final orchestrator = ref.watch(aiOrchestratorProvider);
  return AiRepositoryImpl(orchestrator: orchestrator);
});

/// Generate Daily Insight Provider
final generateDailyInsightProvider = Provider<GenerateDailyInsight>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return GenerateDailyInsight(repository);
});

/// Generate Weekly Summary Provider
final generateWeeklySummaryProvider = Provider<GenerateWeeklySummary>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return GenerateWeeklySummary(repository);
});

/// Analyze Behavior Patterns Provider
final analyzeBehaviorPatternsProvider =
    Provider<AnalyzeBehaviorPatterns>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return AnalyzeBehaviorPatterns(repository);
});

/// Generate Recommendations Provider
final generateRecommendationsProvider =
    Provider<GenerateRecommendations>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return GenerateRecommendations(repository);
});

/// Analyze Reflections Provider
final analyzeReflectionsProvider = Provider<AnalyzeReflections>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return AnalyzeReflections(repository);
});

/// Analyze Goals Provider
final analyzeGoalsProvider = Provider<AnalyzeGoals>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return AnalyzeGoals(repository);
});

/// Analyze Focus Sessions Provider
final analyzeFocusSessionsProvider = Provider<AnalyzeFocusSessions>((ref) {
  final repository = ref.watch(aiRepositoryProvider);
  return AnalyzeFocusSessions(repository);
});

/// AI State Enum
enum AiState { initial, loading, success, error }

/// AI Insight State
class AiInsightState {
  final AiState state;
  final AiInsight? insight;
  final String? error;

  const AiInsightState({
    this.state = AiState.initial,
    this.insight,
    this.error,
  });

  AiInsightState copyWith({
    AiState? state,
    AiInsight? insight,
    String? error,
  }) {
    return AiInsightState(
      state: state ?? this.state,
      insight: insight ?? this.insight,
      error: error ?? this.error,
    );
  }
}

/// AI Insights Notifier
class AiInsightsNotifier extends StateNotifier<AiInsightState> {
  final GenerateDailyInsight _generateDailyInsight;
  final GenerateWeeklySummary _generateWeeklySummary;
  final AnalyzeBehaviorPatterns _analyzeBehaviorPatterns;
  final GenerateRecommendations _generateRecommendations;

  AiInsightsNotifier({
    required GenerateDailyInsight generateDailyInsight,
    required GenerateWeeklySummary generateWeeklySummary,
    required AnalyzeBehaviorPatterns analyzeBehaviorPatterns,
    required GenerateRecommendations generateRecommendations,
  })  : _generateDailyInsight = generateDailyInsight,
        _generateWeeklySummary = generateWeeklySummary,
        _analyzeBehaviorPatterns = analyzeBehaviorPatterns,
        _generateRecommendations = generateRecommendations,
        super(const AiInsightState());

  /// Generate daily insight
  Future<void> generateDailyInsight({
    required Map<String, String> userData,
  }) async {
    state = state.copyWith(state: AiState.loading);

    final result = await _generateDailyInsight(userData: userData);

    result.fold(
      (failure) => state = state.copyWith(
        state: AiState.error,
        error: failure.message,
      ),
      (insight) => state = state.copyWith(
        state: AiState.success,
        insight: insight,
      ),
    );
  }

  /// Generate weekly summary
  Future<void> generateWeeklySummary({
    required Map<String, String> weekData,
  }) async {
    state = state.copyWith(state: AiState.loading);

    final result = await _generateWeeklySummary(weekData: weekData);

    result.fold(
      (failure) => state = state.copyWith(
        state: AiState.error,
        error: failure.message,
      ),
      (summary) => state = state.copyWith(
        state: AiState.success,
      ),
    );
  }

  /// Analyze behavior patterns
  Future<void> analyzeBehaviorPatterns({
    required Map<String, String> behaviorData,
  }) async {
    state = state.copyWith(state: AiState.loading);

    final result = await _analyzeBehaviorPatterns(behaviorData: behaviorData);

    result.fold(
      (failure) => state = state.copyWith(
        state: AiState.error,
        error: failure.message,
      ),
      (patterns) => state = state.copyWith(
        state: AiState.success,
      ),
    );
  }

  /// Generate recommendations
  Future<void> generateRecommendations({
    required Map<String, String> userData,
  }) async {
    state = state.copyWith(state: AiState.loading);

    final result = await _generateRecommendations(userData: userData);

    result.fold(
      (failure) => state = state.copyWith(
        state: AiState.error,
        error: failure.message,
      ),
      (recommendations) => state = state.copyWith(
        state: AiState.success,
      ),
    );
  }

  /// Reset state
  void reset() {
    state = const AiInsightState();
  }
}

/// AI Insights Notifier Provider
final aiInsightsNotifierProvider =
    StateNotifierProvider<AiInsightsNotifier, AiInsightState>((ref) {
  final generateDailyInsight = ref.watch(generateDailyInsightProvider);
  final generateWeeklySummary = ref.watch(generateWeeklySummaryProvider);
  final analyzeBehaviorPatterns = ref.watch(analyzeBehaviorPatternsProvider);
  final generateRecommendations = ref.watch(generateRecommendationsProvider);

  return AiInsightsNotifier(
    generateDailyInsight: generateDailyInsight,
    generateWeeklySummary: generateWeeklySummary,
    analyzeBehaviorPatterns: analyzeBehaviorPatterns,
    generateRecommendations: generateRecommendations,
  );
});
