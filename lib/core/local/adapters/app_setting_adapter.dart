import 'package:hive/hive.dart';

/// App Setting Hive Adapter
class AppSettingAdapter extends TypeAdapter<AppSetting> {
  @override
  final int typeId = 6;

  @override
  AppSetting read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return AppSetting(
      id: fields[0] as String,
      userId: fields[1] as String,
      settingKey: fields[2] as String,
      settingValue: fields[3],
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[4] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(fields[5] as int),
    );
  }

  @override
  void write(BinaryWriter writer, AppSetting obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.settingKey)
      ..writeByte(3)
      ..write(obj.settingValue)
      ..writeByte(4)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(5)
      ..write(obj.updatedAt.millisecondsSinceEpoch);
  }
}

/// App Setting model for Hive
class AppSetting {
  final String id;
  final String userId;
  final String settingKey;
  final dynamic settingValue;
  final DateTime createdAt;
  final DateTime updatedAt;

  AppSetting({
    required this.id,
    required this.userId,
    required this.settingKey,
    required this.settingValue,
    required this.createdAt,
    required this.updatedAt,
  });
}
