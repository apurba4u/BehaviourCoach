import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/daily_reflection/domain/entities/daily_reflection_entity.dart';

/// Daily Reflection Repository Interface
abstract class DailyReflectionRepository {
  /// Create a new daily reflection
  Future<Either<Failure, DailyReflectionEntity>> createReflection({
    required String userId,
    required CreateReflectionParams params,
  });

  /// Get a reflection by ID
  Future<Either<Failure, DailyReflectionEntity>> getReflectionById(
    String reflectionId,
  );

  /// Get all reflections for a user
  Future<Either<Failure, List<DailyReflectionEntity>>> getReflections({
    required String userId,
    ReflectionType? reflectionType,
    int? limit,
    int? offset,
  });

  /// Update a reflection
  Future<Either<Failure, DailyReflectionEntity>> updateReflection({
    required UpdateReflectionParams params,
  });

  /// Delete a reflection
  Future<Either<Failure, void>> deleteReflection(String reflectionId);

  /// Get reflections for a specific date range
  Future<Either<Failure, List<DailyReflectionEntity>>>
      getReflectionsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  });
}
