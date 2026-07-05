import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/focus_session/domain/entities/focus_session_entity.dart';
import 'package:discipline_os/features/focus_session/domain/repositories/focus_session_repository.dart';

/// Start Focus Session Use Case
class StartFocusSession {
  final FocusSessionRepository _repository;

  StartFocusSession(this._repository);

  Future<Either<Failure, FocusSession>> call({
    required String userId,
    required FocusSessionParams params,
  }) {
    return _repository.startSession(userId: userId, params: params);
  }
}
