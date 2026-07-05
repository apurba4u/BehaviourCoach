import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/ai_coach/domain/entities/ai_coach_conversation.dart';
import 'package:discipline_os/features/ai_coach/domain/repositories/ai_coach_repository.dart';

class GetConversationHistory {
  final AiCoachRepository _repository;

  GetConversationHistory(this._repository);

  Future<Either<Failure, AiCoachConversation>> call({
    required String conversationId,
  }) {
    return _repository.getConversation(conversationId: conversationId);
  }
}
