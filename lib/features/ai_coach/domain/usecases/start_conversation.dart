import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/ai_coach/domain/entities/ai_coach_conversation.dart';
import 'package:discipline_os/features/ai_coach/domain/repositories/ai_coach_repository.dart';

class StartConversation {
  final AiCoachRepository _repository;

  StartConversation(this._repository);

  Future<Either<Failure, AiCoachConversation>> call({
    required String userId,
  }) {
    return _repository.startConversation(userId: userId);
  }
}
