import 'package:equatable/equatable.dart';

enum AiCoachMessageRole { user, assistant }

class AiCoachMessage extends Equatable {
  final String id;
  final String content;
  final AiCoachMessageRole role;
  final DateTime timestamp;

  const AiCoachMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
  });

  AiCoachMessage copyWith({
    String? content,
    AiCoachMessageRole? role,
  }) {
    return AiCoachMessage(
      id: id,
      content: content ?? this.content,
      role: role ?? this.role,
      timestamp: timestamp,
    );
  }

  @override
  List<Object?> get props => [id, content, role, timestamp];
}
