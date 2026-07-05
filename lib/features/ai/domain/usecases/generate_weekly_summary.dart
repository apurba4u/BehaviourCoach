import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/ai/errors/ai_failure.dart';
import 'package:discipline_os/features/ai/domain/entities/ai_insight_entity.dart';
import 'package:discipline_os/features/ai/domain/repositories/ai_repository.dart';

/// Generate Weekly Summary Use Case
class GenerateWeeklySummary {
  final AiRepository _repository;

  GenerateWeeklySummary(this._repository);

  Future<Either<AiFailure, AiSummary>> call({
    required Map<String, String> weekData,
  }) {
    return _repository.generateWeeklySummary(weekData: weekData);
  }
}
