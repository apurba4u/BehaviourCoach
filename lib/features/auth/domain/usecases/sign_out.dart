import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/auth/domain/repositories/auth_repository.dart';

/// Sign Out Use Case
class SignOut {
  final AuthRepository _repository;

  SignOut(this._repository);

  Future<Either<Failure, Unit>> call() {
    return _repository.signOut();
  }
}
