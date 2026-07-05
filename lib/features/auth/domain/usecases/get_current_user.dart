import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/auth/domain/entities/user_entity.dart';
import 'package:discipline_os/features/auth/domain/repositories/auth_repository.dart';

/// Get Current User Use Case
class GetCurrentUser {
  final AuthRepository _repository;

  GetCurrentUser(this._repository);

  Future<Either<Failure, UserEntity?>> call() {
    return _repository.getCurrentUser();
  }
}
