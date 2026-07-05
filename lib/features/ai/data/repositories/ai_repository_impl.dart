import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/ai/errors/ai_exception.dart';
import 'package:discipline_os/core/ai/errors/ai_failure.dart';
import 'package:discipline_os/core/ai/services/ai_orchestrator.dart';
import 'package:discipline_os/features/ai/domain/entities/ai_insight_entity.dart';
import 'package:discipline_os/features/ai/domain/repositories/ai_repository.dart';

/// AI Repository Implementation
class AiRepositoryImpl implements AiRepository {
  final AiOrchestrator _orchestrator;

  AiRepositoryImpl({required AiOrchestrator orchestrator})
      : _orchestrator = orchestrator;

  /// Convert AiException to AiFailure
  AiFailure _handleException(Object e) {
    if (e is AiApiKeyException) {
      return AiApiKeyFailure(message: e.message);
    } else if (e is AiRateLimitException) {
      return AiRateLimitFailure(message: e.message);
    } else if (e is AiTimeoutException) {
      return AiTimeoutFailure(message: e.message);
    } else if (e is AiNetworkException) {
      return AiNetworkFailure(message: e.message);
    } else if (e is AiResponseException) {
      return AiResponseFailure(
        message: e.message,
        rawResponse: e.rawResponse,
      );
    } else if (e is AiModelException) {
      return AiModelFailure(message: e.message);
    } else {
      return AiGeneralFailure(message: e.toString());
    }
  }

  /// Safely get string value from dynamic map
  String _asString(dynamic value, [String defaultValue = '']) {
    return value?.toString() ?? defaultValue;
  }

  /// Safely get double value from dynamic
  double _asDouble(dynamic value, [double defaultValue = 0.0]) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? defaultValue;
    return defaultValue;
  }

  /// Safely get list of strings from dynamic
  List<String> _asStringList(dynamic value) {
    if (value is List) return value.map((e) => e.toString()).toList();
    return [];
  }

  @override
  Future<Either<AiFailure, AiInsight>> generateDailyInsight({
    required Map<String, String> userData,
  }) async {
    try {
      final result = await _orchestrator.executeAndParse(
        promptName: 'daily_insight',
        variables: userData,
      );

      return Right(AiInsight(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: 'daily_insight',
        title: _asString(result['title'], 'Daily Insight'),
        insight: _asString(result['insight']),
        actionableTip: result['actionable_tip']?.toString(),
        confidence: _asDouble(result['confidence']),
        category: _asString(result['category'], 'general'),
        generatedAt: DateTime.now(),
      ),
      );
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<AiFailure, AiSummary>> generateWeeklySummary({
    required Map<String, String> weekData,
  }) async {
    try {
      final result = await _orchestrator.executeAndParse(
        promptName: 'weekly_summary',
        variables: weekData,
      );

      final patternsList = result['patterns'] as List<dynamic>? ?? [];
      final patterns = patternsList.map((p) {
        final pattern = p as Map<String, dynamic>;
        return AiPattern(
          pattern: _asString(pattern['pattern']),
          type: _asString(pattern['type']),
          frequency: _asString(pattern['frequency']),
          confidence: _asDouble(pattern['confidence']),
          impact: _asString(pattern['impact'], 'neutral'),
          evidence: _asStringList(pattern['evidence']),
        );
      }).toList();

      final recommendationsList =
          result['recommendations'] as List<dynamic>? ?? [];
      final recommendations = recommendationsList.map((r) {
        final rec = r as Map<String, dynamic>;
        return AiRecommendation(
          action: _asString(rec['action']),
          reason: _asString(rec['reason']),
          priority: _asString(rec['priority'], 'medium'),
          expectedImpact: rec['expected_impact']?.toString(),
        );
      }).toList();

      return Right(AiSummary(
        summary: _asString(result['summary']),
        highlights: _asStringList(result['highlights']),
        challenges: _asStringList(result['challenges']),
        patterns: patterns,
        recommendations: recommendations,
        scoreTrend: _asString(result['score_trend'], 'stable'),
        consistencyPercentage:
            _asDouble(result['consistency_percentage']),
      ),
      );
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<AiFailure, List<AiPattern>>> analyzeBehaviorPatterns({
    required Map<String, String> behaviorData,
  }) async {
    try {
      final result = await _orchestrator.executeAndParse(
        promptName: 'behavior_analysis',
        variables: behaviorData,
      );

      final patternsList = result['patterns'] as List<dynamic>? ?? [];
      final patterns = patternsList.map((p) {
        final pattern = p as Map<String, dynamic>;
        return AiPattern(
          pattern: _asString(pattern['description']),
          type: _asString(pattern['type']),
          frequency: _asString(pattern['frequency']),
          confidence: _asDouble(pattern['confidence']),
          impact: _asString(pattern['impact'], 'neutral'),
          evidence: _asStringList(pattern['evidence']),
        );
      }).toList();

      return Right(patterns);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<AiFailure, Map<String, dynamic>>> analyzeReflections({
    required Map<String, String> reflectionData,
  }) async {
    try {
      final result = await _orchestrator.executeAndParse(
        promptName: 'reflection_analysis',
        variables: reflectionData,
      );

      return Right(result);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<AiFailure, Map<String, dynamic>>> analyzeGoals({
    required Map<String, String> goalData,
  }) async {
    try {
      final result = await _orchestrator.executeAndParse(
        promptName: 'goal_analysis',
        variables: goalData,
      );

      return Right(result);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<AiFailure, Map<String, dynamic>>> analyzeFocusSessions({
    required Map<String, String> focusData,
  }) async {
    try {
      final result = await _orchestrator.executeAndParse(
        promptName: 'focus_analysis',
        variables: focusData,
      );

      return Right(result);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<AiFailure, List<AiRecommendation>>> generateRecommendations({
    required Map<String, String> userData,
  }) async {
    try {
      final result = await _orchestrator.executeAndParse(
        promptName: 'recommendation_engine',
        variables: userData,
      );

      final recommendations = <AiRecommendation>[];

      // Add immediate action
      if (result['immediate_action'] != null) {
        final action = result['immediate_action'] as Map<String, dynamic>;
        recommendations.add(AiRecommendation(
          action: _asString(action['what']),
          reason: _asString(action['why']),
          priority: 'high',
          expectedImpact: action['expected_benefit']?.toString(),
        ),
        );
      }

      // Add today's recommendations
      final todayRecs = result['today_recommendations'] as List<dynamic>? ?? [];
      for (final r in todayRecs) {
        final rec = r as Map<String, dynamic>;
        recommendations.add(AiRecommendation(
          action: _asString(rec['action']),
          reason: _asString(rec['basis']),
          priority: _asString(rec['priority'], 'medium'),
          timeEstimate: rec['time_estimate']?.toString(),
        ),
        );
      }

      return Right(recommendations);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<AiFailure, Map<String, dynamic>>> generateBehavioralSummary({
    required Map<String, String> summaryData,
  }) async {
    try {
      final result = await _orchestrator.executeAndParse(
        promptName: 'behavioral_summary',
        variables: summaryData,
      );

      return Right(result);
    } catch (e) {
      return Left(_handleException(e));
    }
  }

  @override
  Future<Either<AiFailure, Map<String, dynamic>>> analyzeDiscipline({
    required Map<String, String> disciplineData,
  }) async {
    try {
      final result = await _orchestrator.executeAndParse(
        promptName: 'discipline_analysis',
        variables: disciplineData,
      );

      return Right(result);
    } catch (e) {
      return Left(_handleException(e));
    }
  }
}
