import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/ai/errors/ai_failure.dart';
import 'package:discipline_os/features/ai/domain/repositories/ai_repository.dart';

/// Analyze Goals Use Case
class AnalyzeGoals {
  final AiRepository _repository;

  AnalyzeGoals(this._repository);

  Future<Either<AiFailure, Map<String, dynamic>>> call({
    required Map<String, String> goalData,
  }) {
    return _repository.analyzeGoals(goalData: goalData);
  }
}
