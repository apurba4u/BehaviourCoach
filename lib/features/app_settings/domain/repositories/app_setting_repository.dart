import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/app_settings/domain/entities/app_setting_entity.dart';

/// App Setting Repository Interface
abstract class AppSettingRepository {
  Future<Either<Failure, AppSettingEntity>> getSetting({
    required String userId,
    required String settingKey,
  });

  Future<Either<Failure, List<AppSettingEntity>>> getAllSettings(String userId);

  Future<Either<Failure, AppSettingEntity>> upsertSetting({
    required String userId,
    required String settingKey,
    required dynamic settingValue,
  });

  Future<Either<Failure, Unit>> deleteSetting({
    required String userId,
    required String settingKey,
  });
}
