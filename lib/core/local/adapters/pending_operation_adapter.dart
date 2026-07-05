import 'package:hive/hive.dart';

/// Pending Operation Hive Adapter
class PendingOperationAdapter extends TypeAdapter<PendingOperation> {
  @override
  final int typeId = 7;

  @override
  PendingOperation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return PendingOperation(
      id: fields[0] as String,
      entityType: fields[1] as String,
      entityId: fields[2] as String,
      operation: fields[3] as String,
      data: fields[4] != null
          ? Map<String, dynamic>.from(fields[4] as Map)
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[5] as int),
      retryCount: fields[6] as int,
      lastError: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PendingOperation obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.entityType)
      ..writeByte(2)
      ..write(obj.entityId)
      ..writeByte(3)
      ..write(obj.operation)
      ..writeByte(4)
      ..write(obj.data)
      ..writeByte(5)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(6)
      ..write(obj.retryCount)
      ..writeByte(7)
      ..write(obj.lastError);
  }
}

/// Pending Operation model for sync queue
class PendingOperation {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final Map<String, dynamic>? data;
  final DateTime createdAt;
  final int retryCount;
  final String? lastError;

  PendingOperation({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    this.data,
    required this.createdAt,
    this.retryCount = 0,
    this.lastError,
  });

  PendingOperation copyWith({
    int? retryCount,
    String? lastError,
  }) {
    return PendingOperation(
      id: id,
      entityType: entityType,
      entityId: entityId,
      operation: operation,
      data: data,
      createdAt: createdAt,
      retryCount: retryCount ?? this.retryCount,
      lastError: lastError ?? this.lastError,
    );
  }
}
