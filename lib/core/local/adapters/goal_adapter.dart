import 'package:hive/hive.dart';

/// Goal Hive Adapter
class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 3;

  @override
  Goal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return Goal(
      id: fields[0] as String,
      userId: fields[1] as String,
      title: fields[2] as String,
      description: fields[3] as String?,
      category: fields[4] as String?,
      targetValue: fields[5] as int?,
      currentValue: fields[6] as int,
      unit: fields[7] as String?,
      status: fields[8] as String,
      deadline: fields[9] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[9] as int)
          : null,
      completedAt: fields[10] != null
          ? DateTime.fromMillisecondsSinceEpoch(fields[10] as int)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[11] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(fields[12] as int),
    );
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.targetValue)
      ..writeByte(6)
      ..write(obj.currentValue)
      ..writeByte(7)
      ..write(obj.unit)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.deadline?.millisecondsSinceEpoch)
      ..writeByte(10)
      ..write(obj.completedAt?.millisecondsSinceEpoch)
      ..writeByte(11)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(12)
      ..write(obj.updatedAt.millisecondsSinceEpoch);
  }
}

/// Goal model for Hive
class Goal {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String? category;
  final int? targetValue;
  final int currentValue;
  final String? unit;
  final String status;
  final DateTime? deadline;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Goal({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.category,
    this.targetValue,
    this.currentValue = 0,
    this.unit,
    this.status = 'active',
    this.deadline,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });
}
