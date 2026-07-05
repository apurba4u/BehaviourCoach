import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/focus_session/domain/entities/focus_session_entity.dart';
import 'package:discipline_os/features/focus_session/domain/repositories/focus_session_repository.dart';

/// Resume Focus Session Use Case
class ResumeFocusSession {
  final FocusSessionRepository _repository;

  ResumeFocusSession(this._repository);

  Future<Either<Failure, FocusSession>> call(String sessionId) {
    return _repository.resumeSession(sessionId);
  }
}
