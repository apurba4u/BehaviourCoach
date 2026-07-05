import 'package:hive/hive.dart';

/// Daily Reflection Hive Adapter
class DailyReflectionAdapter extends TypeAdapter<DailyReflection> {
  @override
  final int typeId = 2;

  @override
  DailyReflection read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return DailyReflection(
      id: fields[0] as String,
      userId: fields[1] as String,
      reflectionType: fields[2] as String,
      mood: fields[3] as String?,
      energyLevel: fields[4] as int?,
      content: fields[5] as String?,
      voiceUrl: fields[6] as String?,
      aiSynthesis: fields[7] as String?,
      recordedAt: DateTime.fromMillisecondsSinceEpoch(fields[8] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[9] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(fields[10] as int),
    );
  }

  @override
  void write(BinaryWriter writer, DailyReflection obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.reflectionType)
      ..writeByte(3)
      ..write(obj.mood)
      ..writeByte(4)
      ..write(obj.energyLevel)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.voiceUrl)
      ..writeByte(7)
      ..write(obj.aiSynthesis)
      ..writeByte(8)
      ..write(obj.recordedAt.millisecondsSinceEpoch)
      ..writeByte(9)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(10)
      ..write(obj.updatedAt.millisecondsSinceEpoch);
  }
}

/// Daily Reflection model for Hive
class DailyReflection {
  final String id;
  final String userId;
  final String reflectionType;
  final String? mood;
  final int? energyLevel;
  final String? content;
  final String? voiceUrl;
  final String? aiSynthesis;
  final DateTime recordedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DailyReflection({
    required this.id,
    required this.userId,
    required this.reflectionType,
    this.mood,
    this.energyLevel,
    this.content,
    this.voiceUrl,
    this.aiSynthesis,
    required this.recordedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
