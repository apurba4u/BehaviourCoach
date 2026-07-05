import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/ai/errors/ai_failure.dart';
import 'package:discipline_os/features/ai/domain/repositories/ai_repository.dart';

/// Analyze Reflections Use Case
class AnalyzeReflections {
  final AiRepository _repository;

  AnalyzeReflections(this._repository);

  Future<Either<AiFailure, Map<String, dynamic>>> call({
    required Map<String, String> reflectionData,
  }) {
    return _repository.analyzeReflections(reflectionData: reflectionData);
  }
}
