import 'package:equatable/equatable.dart';

/// Daily Reflection Entity
class DailyReflectionEntity extends Equatable {
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

  const DailyReflectionEntity({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        reflectionType,
        mood,
        energyLevel,
        content,
        voiceUrl,
        aiSynthesis,
        recordedAt,
        createdAt,
        updatedAt,
      ];
}
