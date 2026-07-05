import 'package:discipline_os/features/ai_coach/domain/entities/ai_coach_message.dart';
import 'package:equatable/equatable.dart';

class AiCoachConversation extends Equatable {
  final String id;
  final String userId;
  final List<AiCoachMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AiCoachConversation({
    required this.id,
    required this.userId,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  int get messageCount => messages.length;

  AiCoachMessage? get lastMessage => messages.isNotEmpty ? messages.last : null;

  AiCoachConversation copyWith({
    List<AiCoachMessage>? messages,
    DateTime? updatedAt,
  }) {
    return AiCoachConversation(
      id: id,
      userId: userId,
      messages: messages ?? this.messages,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, messages, createdAt, updatedAt];
}
