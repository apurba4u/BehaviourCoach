import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/daily_reflection/domain/entities/daily_reflection_entity.dart';
import 'package:discipline_os/features/daily_reflection/domain/repositories/daily_reflection_repository.dart';

/// Create Reflection Use Case
class CreateReflection {
  final DailyReflectionRepository _repository;

  CreateReflection(this._repository);

  Future<Either<Failure, DailyReflectionEntity>> call({
    required String userId,
    required CreateReflectionParams params,
  }) {
    return _repository.createReflection(userId: userId, params: params);
  }
}
