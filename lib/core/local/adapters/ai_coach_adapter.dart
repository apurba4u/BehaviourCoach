import 'package:hive/hive.dart';

class AiCoachConversationCache {
  final String id;
  final String userId;
  final List<AiCoachMessageCache> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  AiCoachConversationCache({
    required this.id,
    required this.userId,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });
}

class AiCoachMessageCache {
  final String id;
  final String content;
  final String role;
  final DateTime timestamp;

  AiCoachMessageCache({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
  });
}

class AiCoachConversationAdapter extends TypeAdapter<AiCoachConversationCache> {
  @override
  final int typeId = 8;

  @override
  AiCoachConversationCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    final rawMessages = fields[2] as List;
    final messages = rawMessages
        .map((m) => AiCoachMessageCache(
              id: (m as Map)['id'] as String,
              content: m['content'] as String,
              role: m['role'] as String,
              timestamp:
                  DateTime.fromMillisecondsSinceEpoch(m['timestamp'] as int),
            ))
        .toList();
    return AiCoachConversationCache(
      id: fields[0] as String,
      userId: fields[1] as String,
      messages: messages,
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[3] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(fields[4] as int),
    );
  }

  @override
  void write(BinaryWriter writer, AiCoachConversationCache obj) {
    final messagesData = obj.messages
        .map((m) => {
              'id': m.id,
              'content': m.content,
              'role': m.role,
              'timestamp': m.timestamp.millisecondsSinceEpoch,
            })
        .toList();
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(messagesData)
      ..writeByte(3)
      ..write(obj.createdAt.millisecondsSinceEpoch)
      ..writeByte(4)
      ..write(obj.updatedAt.millisecondsSinceEpoch);
  }
}
