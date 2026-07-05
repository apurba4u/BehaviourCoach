import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/ai/errors/ai_failure.dart';
import 'package:discipline_os/features/ai/domain/repositories/ai_repository.dart';

/// Analyze Focus Sessions Use Case
class AnalyzeFocusSessions {
  final AiRepository _repository;

  AnalyzeFocusSessions(this._repository);

  Future<Either<AiFailure, Map<String, dynamic>>> call({
    required Map<String, String> focusData,
  }) {
    return _repository.analyzeFocusSessions(focusData: focusData);
  }
}
