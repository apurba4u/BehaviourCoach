import 'package:hive/hive.dart';

/// AI Insight Hive Adapter
class AiInsightAdapter extends TypeAdapter<AiInsightCache> {
  @override
  final int typeId = 5;

  @override
  AiInsightCache read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return AiInsightCache(
      id: fields[0] as String,
      userId: fields[1] as String,
      insightType: fields[2] as String,
      title: fields[3] as String,
      content: fields[4] as String,
      confidenceScore: fields[5] as double?,
      metadata: Map<String, dynamic>.from(fields[6] as Map),
      isRead: fields[7] as bool,
      isDismissed: fields[8] as bool,
      generatedAt: DateTime.fromMillisecondsSinceEpoch(fields[9] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(fields[10] as int),
    );
  }

  @override
  void write(BinaryWriter writer, AiInsightCache obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.insightType)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.confidenceScore)
      ..writeByte(6)
      ..write(obj.metadata)
      ..writeByte(7)
      ..write(obj.isRead)
      ..writeByte(8)
      ..write(obj.isDismissed)
      ..writeByte(9)
      ..write(obj.generatedAt.millisecondsSinceEpoch)
      ..writeByte(10)
      ..write(obj.createdAt.millisecondsSinceEpoch);
  }
}

/// AI Insight model for Hive cache
class AiInsightCache {
  final String id;
  final String userId;
  final String insightType;
  final String title;
  final String content;
  final double? confidenceScore;
  final Map<String, dynamic> metadata;
  final bool isRead;
  final bool isDismissed;
  final DateTime generatedAt;
  final DateTime createdAt;

  AiInsightCache({
    required this.id,
    required this.userId,
    required this.insightType,
    required this.title,
    required this.content,
    this.confidenceScore,
    this.metadata = const {},
    this.isRead = false,
    this.isDismissed = false,
    required this.generatedAt,
    required this.createdAt,
  });
}
