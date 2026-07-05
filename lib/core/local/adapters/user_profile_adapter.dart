import 'package:hive/hive.dart';

/// User Profile Hive Adapter
class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return UserProfile(
      id: fields[0] as String,
      email: fields[1] as String,
      displayName: fields[2] as String?,
      avatarUrl: fields[3] as String?,
      identityLevel: fields[4] as String,
      identityScore: fields[5] as int,
      timezone: fields[6] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[7] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(fields[8] as int),
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.displayName)
      ..writeByte(3)
      ..write(obj.avatarUrl)
      ..writeByte(4)
      ..write(obj.identityLevel)
      ..writeByte(5)
      ..write(obj.identityScore)
      ..writeByte(6)
      ..write(obj.timezone)
      ..writeByte(7)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(8)
      ..write(obj.updatedAt.millisecondsSinceEpoch);
  }
}

/// User Profile model for Hive
class UserProfile {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String identityLevel;
  final int identityScore;
  final String timezone;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.identityLevel = 'novice',
    this.identityScore = 0,
    this.timezone = 'UTC',
    required this.createdAt,
    required this.updatedAt,
  });
}
