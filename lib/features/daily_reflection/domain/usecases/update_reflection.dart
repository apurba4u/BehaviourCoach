import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/daily_reflection/domain/entities/daily_reflection_entity.dart';
import 'package:discipline_os/features/daily_reflection/domain/repositories/daily_reflection_repository.dart';

/// Update Reflection Use Case
class UpdateReflection {
  final DailyReflectionRepository _repository;

  UpdateReflection(this._repository);

  Future<Either<Failure, DailyReflectionEntity>> call({
    required UpdateReflectionParams params,
  }) {
    return _repository.updateReflection(params: params);
  }
}
