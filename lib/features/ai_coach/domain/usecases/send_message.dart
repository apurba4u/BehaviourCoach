import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/ai_coach/domain/entities/ai_coach_conversation.dart';
import 'package:discipline_os/features/ai_coach/domain/repositories/ai_coach_repository.dart';

class SendMessage {
  final AiCoachRepository _repository;

  SendMessage(this._repository);

  Future<Either<Failure, AiCoachConversation>> call({
    required String conversationId,
    required String content,
  }) {
    return _repository.sendMessage(
      conversationId: conversationId,
      content: content,
    );
  }
}
