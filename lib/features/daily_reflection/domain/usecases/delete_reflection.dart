import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/daily_reflection/domain/repositories/daily_reflection_repository.dart';

/// Delete Reflection Use Case
class DeleteReflection {
  final DailyReflectionRepository _repository;

  DeleteReflection(this._repository);

  Future<Either<Failure, void>> call(String reflectionId) {
    return _repository.deleteReflection(reflectionId);
  }
}
