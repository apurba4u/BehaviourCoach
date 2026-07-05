import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/focus_session/domain/entities/focus_session_entity.dart';

/// Focus Session Repository Interface
abstract class FocusSessionRepository {
  /// Start a new focus session
  Future<Either<Failure, FocusSession>> startSession({
    required String userId,
    required FocusSessionParams params,
  });

  /// Pause an active session
  Future<Either<Failure, FocusSession>> pauseSession(String sessionId);

  /// Resume a paused session
  Future<Either<Failure, FocusSession>> resumeSession(String sessionId);

  /// End a session
  Future<Either<Failure, FocusSession>> endSession({
    required String sessionId,
    int? score,
    int? distractionsCount,
  });

  /// Cancel a session
  Future<Either<Failure, FocusSession>> cancelSession(String sessionId);

  /// Get a session by ID
  Future<Either<Failure, FocusSession>> getSessionById(String sessionId);

  /// Get all sessions for a user
  Future<Either<Failure, List<FocusSession>>> getSessions({
    required String userId,
    String? status,
    int? limit,
    int? offset,
  });

  /// Get active session for a user
  Future<Either<Failure, FocusSession?>> getActiveSession(String userId);

  /// Get session statistics
  Future<Either<Failure, Map<String, dynamic>>> getSessionStats({
    required String userId,
  });
}
