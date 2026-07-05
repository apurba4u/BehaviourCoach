import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/daily_reflections/domain/entities/daily_reflection_entity.dart';

/// Daily Reflection Repository Interface
abstract class DailyReflectionRepository {
  Future<Either<Failure, DailyReflectionEntity>> createReflection({
    required String userId,
    required String reflectionType,
    String? mood,
    int? energyLevel,
    String? content,
    String? voiceUrl,
  });

  Future<Either<Failure, List<DailyReflectionEntity>>> getReflections({
    required String userId,
    String? reflectionType,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, DailyReflectionEntity>> getReflectionById(String reflectionId);

  Future<Either<Failure, DailyReflectionEntity>> updateReflection({
    required String reflectionId,
    String? mood,
    int? energyLevel,
    String? content,
    String? voiceUrl,
    String? aiSynthesis,
  });

  Future<Either<Failure, Unit>> deleteReflection(String reflectionId);
}
