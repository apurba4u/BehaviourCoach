import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/focus_sessions/domain/entities/focus_session_entity.dart';

/// Focus Session Repository Interface
abstract class FocusSessionRepository {
  Future<Either<Failure, FocusSessionEntity>> startSession({
    required String userId,
    String? title,
    String? protocol,
    required int durationMinutes,
    String? ambientSound,
  });

  Future<Either<Failure, FocusSessionEntity>> pauseSession(String sessionId);

  Future<Either<Failure, FocusSessionEntity>> resumeSession(String sessionId);

  Future<Either<Failure, FocusSessionEntity>> endSession({
    required String sessionId,
    int? score,
    int? distractionsCount,
  });

  Future<Either<Failure, FocusSessionEntity>> cancelSession(String sessionId);

  Future<Either<Failure, List<FocusSessionEntity>>> getSessions({
    required String userId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, FocusSessionEntity>> getSessionById(String sessionId);

  Future<Either<Failure, Map<String, dynamic>>> getSessionStats({
    required String userId,
    DateTime? startDate,
    DateTime? endDate,
  });
}
