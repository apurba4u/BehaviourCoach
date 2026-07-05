import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/focus_session/domain/entities/focus_session_entity.dart';
import 'package:discipline_os/features/focus_session/domain/repositories/focus_session_repository.dart';

/// End Focus Session Use Case
class EndFocusSession {
  final FocusSessionRepository _repository;

  EndFocusSession(this._repository);

  Future<Either<Failure, FocusSession>> call({
    required String sessionId,
    int? score,
    int? distractionsCount,
  }) {
    return _repository.endSession(
      sessionId: sessionId,
      score: score,
      distractionsCount: distractionsCount,
    );
  }
}
