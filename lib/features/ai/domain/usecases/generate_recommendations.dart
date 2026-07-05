import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/ai/errors/ai_failure.dart';
import 'package:discipline_os/features/ai/domain/entities/ai_insight_entity.dart';
import 'package:discipline_os/features/ai/domain/repositories/ai_repository.dart';

/// Generate Recommendations Use Case
class GenerateRecommendations {
  final AiRepository _repository;

  GenerateRecommendations(this._repository);

  Future<Either<AiFailure, List<AiRecommendation>>> call({
    required Map<String, String> userData,
  }) {
    return _repository.generateRecommendations(userData: userData);
  }
}
