import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/user_profile/domain/entities/user_profile_entity.dart';

/// User Profile Repository Interface
abstract class UserProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getProfile(String userId);
  Future<Either<Failure, UserProfileEntity>> updateProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
    String? identityLevel,
    int? identityScore,
  });
  Stream<UserProfileEntity> watchProfile(String userId);
}
