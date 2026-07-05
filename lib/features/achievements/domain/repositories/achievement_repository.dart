import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/achievements/domain/entities/achievement_entity.dart';

/// Achievement Repository Interface
abstract class AchievementRepository {
  Future<Either<Failure, AchievementEntity>> createAchievement({
    required String userId,
    required String achievementType,
    required String title,
    String? description,
    String? icon,
    String? color,
  });

  Future<Either<Failure, List<AchievementEntity>>> getAchievements({
    required String userId,
    String? achievementType,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, AchievementEntity>> getAchievementById(
    String achievementId,
  );
}
