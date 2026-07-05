import 'package:hive/hive.dart';

/// Behavioral Log Hive Adapter
class BehavioralLogAdapter extends TypeAdapter<BehavioralLog> {
  @override
  final int typeId = 1;

  @override
  BehavioralLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return BehavioralLog(
      id: fields[0] as String,
      userId: fields[1] as String,
      logType: fields[2] as String,
      score: fields[3] as int?,
      durationMinutes: fields[4] as int?,
      metadata: Map<String, dynamic>.from(fields[5] as Map),
      recordedAt: DateTime.fromMillisecondsSinceEpoch(fields[6] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[7] as int),
    );
  }

  @override
  void write(BinaryWriter writer, BehavioralLog obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.logType)
      ..writeByte(3)
      ..write(obj.score)
      ..writeByte(4)
      ..write(obj.durationMinutes)
      ..writeByte(5)
      ..write(obj.metadata)
      ..writeByte(6)
      ..write(obj.recordedAt.millisecondsSinceEpoch)
      ..writeByte(7)
      ..write(obj.createdAt.millisecondsSinceEpoch);
  }
}

/// Behavioral Log model for Hive
class BehavioralLog {
  final String id;
  final String userId;
  final String logType;
  final int? score;
  final int? durationMinutes;
  final Map<String, dynamic> metadata;
  final DateTime recordedAt;
  final DateTime createdAt;

  BehavioralLog({
    required this.id,
    required this.userId,
    required this.logType,
    this.score,
    this.durationMinutes,
    this.metadata = const {},
    required this.recordedAt,
    required this.createdAt,
  });
}
