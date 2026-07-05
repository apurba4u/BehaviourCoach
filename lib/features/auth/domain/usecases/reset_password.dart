import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/auth/domain/repositories/auth_repository.dart';

/// Reset Password Use Case
class ResetPassword {
  final AuthRepository _repository;

  ResetPassword(this._repository);

  Future<Either<Failure, Unit>> call(String email) {
    return _repository.resetPassword(email);
  }
}
