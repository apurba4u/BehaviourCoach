import 'package:equatable/equatable.dart';

/// Daily Reflection Entity
class DailyReflectionEntity extends Equatable {
  final String id;
  final String userId;
  final ReflectionType reflectionType;
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

  /// Create a copy with updates
  DailyReflectionEntity copyWith({
    String? mood,
    int? energyLevel,
    String? content,
    String? voiceUrl,
    String? aiSynthesis,
    DateTime? recordedAt,
    DateTime? updatedAt,
  }) {
    return DailyReflectionEntity(
      id: id,
      userId: userId,
      reflectionType: reflectionType,
      mood: mood ?? this.mood,
      energyLevel: energyLevel ?? this.energyLevel,
      content: content ?? this.content,
      voiceUrl: voiceUrl ?? this.voiceUrl,
      aiSynthesis: aiSynthesis ?? this.aiSynthesis,
      recordedAt: recordedAt ?? this.recordedAt,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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

/// Reflection Type enum
enum ReflectionType {
  morning('morning'),
  evening('evening');

  final String value;

  const ReflectionType(this.value);
}

/// Create Reflection Params
class CreateReflectionParams extends Equatable {
  final String userId;
  final ReflectionType reflectionType;
  final String? mood;
  final int? energyLevel;
  final String? content;
  final String? voiceUrl;
  final DateTime? recordedAt;

  const CreateReflectionParams({
    required this.userId,
    required this.reflectionType,
    this.mood,
    this.energyLevel,
    this.content,
    this.voiceUrl,
    this.recordedAt,
  });

  @override
  List<Object?> get props => [
        userId,
        reflectionType,
        mood,
        energyLevel,
        content,
        voiceUrl,
        recordedAt,
      ];
}

/// Update Reflection Params
class UpdateReflectionParams extends Equatable {
  final String id;
  final String? mood;
  final int? energyLevel;
  final String? content;
  final String? voiceUrl;
  final String? aiSynthesis;

  const UpdateReflectionParams({
    required this.id,
    this.mood,
    this.energyLevel,
    this.content,
    this.voiceUrl,
    this.aiSynthesis,
  });

  @override
  List<Object?> get props => [
        id,
        mood,
        energyLevel,
        content,
        voiceUrl,
        aiSynthesis,
      ];
}
