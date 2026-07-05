import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/ai/errors/ai_failure.dart';
import 'package:discipline_os/features/ai/domain/entities/ai_insight_entity.dart';
import 'package:discipline_os/features/ai/domain/repositories/ai_repository.dart';

/// Analyze Behavior Patterns Use Case
class AnalyzeBehaviorPatterns {
  final AiRepository _repository;

  AnalyzeBehaviorPatterns(this._repository);

  Future<Either<AiFailure, List<AiPattern>>> call({
    required Map<String, String> behaviorData,
  }) {
    return _repository.analyzeBehaviorPatterns(behaviorData: behaviorData);
  }
}
