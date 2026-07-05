import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/focus_session/domain/entities/focus_session_entity.dart';
import 'package:discipline_os/features/focus_session/domain/repositories/focus_session_repository.dart';

/// Get Active Session Use Case
class GetActiveSession {
  final FocusSessionRepository _repository;

  GetActiveSession(this._repository);

  Future<Either<Failure, FocusSession?>> call(String userId) {
    return _repository.getActiveSession(userId);
  }
}
