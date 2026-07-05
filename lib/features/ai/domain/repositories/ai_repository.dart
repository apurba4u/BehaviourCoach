import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/ai/errors/ai_failure.dart';
import 'package:discipline_os/features/ai/domain/entities/ai_insight_entity.dart';

/// AI Repository Interface
abstract class AiRepository {
  /// Generate a daily insight based on user data
  Future<Either<AiFailure, AiInsight>> generateDailyInsight({
    required Map<String, String> userData,
  });

  /// Generate a weekly summary
  Future<Either<AiFailure, AiSummary>> generateWeeklySummary({
    required Map<String, String> weekData,
  });

  /// Analyze behavioral patterns
  Future<Either<AiFailure, List<AiPattern>>> analyzeBehaviorPatterns({
    required Map<String, String> behaviorData,
  });

  /// Analyze reflections
  Future<Either<AiFailure, Map<String, dynamic>>> analyzeReflections({
    required Map<String, String> reflectionData,
  });

  /// Analyze goals
  Future<Either<AiFailure, Map<String, dynamic>>> analyzeGoals({
    required Map<String, String> goalData,
  });

  /// Analyze focus sessions
  Future<Either<AiFailure, Map<String, dynamic>>> analyzeFocusSessions({
    required Map<String, String> focusData,
  });

  /// Generate personalized recommendations
  Future<Either<AiFailure, List<AiRecommendation>>> generateRecommendations({
    required Map<String, String> userData,
  });

  /// Generate behavioral summary
  Future<Either<AiFailure, Map<String, dynamic>>> generateBehavioralSummary({
    required Map<String, String> summaryData,
  });

  /// Analyze discipline patterns
  Future<Either<AiFailure, Map<String, dynamic>>> analyzeDiscipline({
    required Map<String, String> disciplineData,
  });
}
