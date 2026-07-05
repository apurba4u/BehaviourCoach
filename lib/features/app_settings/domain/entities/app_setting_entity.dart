import 'package:equatable/equatable.dart';

/// App Setting Entity
class AppSettingEntity extends Equatable {
  final String id;
  final String userId;
  final String settingKey;
  final dynamic settingValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AppSettingEntity({
    required this.id,
    required this.userId,
    required this.settingKey,
    required this.settingValue,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        settingKey,
        settingValue,
        createdAt,
        updatedAt,
      ];
}
