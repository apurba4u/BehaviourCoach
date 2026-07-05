import 'package:hive/hive.dart';

/// Focus Session Hive Adapter
class FocusSessionAdapter extends TypeAdapter<FocusSessionCache> {
  @override
  final int typeId = 4;

  @override
  FocusSessionCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return FocusSessionCache(
      id: fields[0] as String,
      userId: fields[1] as String,
      title: fields[2] as String?,
      protocol: fields[3] as String?,
      durationMinutes: fields[4] as int,
      actualMinutes: fields[5] as int?,
      status: fields[6] as String,
      score: fields[7] as int?,
      ambientSound: fields[8] as String?,
      distractionsCount: fields[9] as int,
      startedAt: DateTime.fromMillisecondsSinceEpoch(fields[10] as int),
      endedAt: fields[11] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[11] as int)
          : null,
      pausedAt: fields[12] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[12] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[13] as int),
    );
  }

  @override
  void write(BinaryWriter writer, FocusSessionCache obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.protocol)
      ..writeByte(4)
      ..write(obj.durationMinutes)
      ..writeByte(5)
      ..write(obj.actualMinutes)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.score)
      ..writeByte(8)
      ..write(obj.ambientSound)
      ..writeByte(9)
      ..write(obj.distractionsCount)
      ..writeByte(10)
      ..write(obj.startedAt.millisecondsSinceEpoch)
      ..writeByte(11)
      ..write(obj.endedAt?.millisecondsSinceEpoch)
      ..writeByte(12)
      ..write(obj.pausedAt?.millisecondsSinceEpoch)
      ..writeByte(13)
      ..write(obj.createdAt.millisecondsSinceEpoch);
  }
}

/// Focus Session model for Hive
class FocusSessionCache {
  final String id;
  final String userId;
  final String? title;
  final String? protocol;
  final int durationMinutes;
  final int? actualMinutes;
  final String status;
  final int? score;
  final String? ambientSound;
  final int distractionsCount;
  final DateTime startedAt;
  final DateTime? endedAt;
  final DateTime? pausedAt;
  final DateTime createdAt;

  FocusSessionCache({
    required this.id,
    required this.userId,
    this.title,
    this.protocol,
    required this.durationMinutes,
    this.actualMinutes,
    this.status = 'active',
    this.score,
    this.ambientSound,
    this.distractionsCount = 0,
    required this.startedAt,
    this.endedAt,
    this.pausedAt,
    required this.createdAt,
  });
}
