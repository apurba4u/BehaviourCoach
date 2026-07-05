import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/daily_reflection/domain/entities/daily_reflection_entity.dart';
import 'package:discipline_os/features/daily_reflection/domain/repositories/daily_reflection_repository.dart';

/// Get Reflections Use Case
class GetReflections {
  final DailyReflectionRepository _repository;

  GetReflections(this._repository);

  Future<Either<Failure, List<DailyReflectionEntity>>> call({
    required String userId,
    ReflectionType? reflectionType,
    int? limit,
    int? offset,
  }) {
    return _repository.getReflections(
      userId: userId,
      reflectionType: reflectionType,
      limit: limit,
      offset: offset,
    );
  }
}
