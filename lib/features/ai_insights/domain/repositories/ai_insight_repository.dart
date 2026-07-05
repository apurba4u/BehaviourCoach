import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/ai_insights/domain/entities/ai_insight_entity.dart';

/// AI Insight Repository Interface
abstract class AiInsightRepository {
  Future<Either<Failure, AiInsightEntity>> createInsight({
    required String userId,
    required String insightType,
    required String title,
    required String content,
    double? confidenceScore,
    Map<String, dynamic>? metadata,
  });

  Future<Either<Failure, List<AiInsightEntity>>> getInsights({
    required String userId,
    String? insightType,
    bool? isRead,
    bool? isDismissed,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, AiInsightEntity>> getInsightById(String insightId);

  Future<Either<Failure, AiInsightEntity>> markAsRead(String insightId);

  Future<Either<Failure, AiInsightEntity>> dismissInsight(String insightId);

  Future<Either<Failure, Unit>> deleteInsight(String insightId);
}
