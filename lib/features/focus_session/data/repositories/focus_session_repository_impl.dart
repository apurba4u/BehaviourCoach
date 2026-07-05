import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/core/local/cache/cache_manager.dart';
import 'package:discipline_os/core/local/adapters/behavioral_log_adapter.dart'
    as local;
import 'package:discipline_os/core/local/adapters/focus_session_adapter.dart'
    as local;
import 'package:discipline_os/core/sync/sync_manager.dart';
import 'package:discipline_os/core/utils/logger.dart';
import 'package:discipline_os/features/focus_session/domain/entities/focus_session_entity.dart'
    as domain;
import 'package:discipline_os/features/focus_session/domain/repositories/focus_session_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

/// Focus Session Repository Implementation
class FocusSessionRepositoryImpl implements FocusSessionRepository {
  final CacheManager _cacheManager;
  final SupabaseClient _supabaseClient;
  final SyncManager _syncManager;

  FocusSessionRepositoryImpl({
    CacheManager? cacheManager,
    SupabaseClient? supabaseClient,
    SyncManager? syncManager,
  })  : _cacheManager = cacheManager ?? CacheManager.instance,
        _supabaseClient = supabaseClient ?? Supabase.instance.client,
        _syncManager = syncManager ?? SyncManager.instance;

  @override
  Future<Either<Failure, domain.FocusSession>> startSession({
    required String userId,
    required domain.FocusSessionParams params,
  }) async {
    try {
      final sessionId = const Uuid().v4();
      final now = DateTime.now();

      final session = domain.FocusSession(
        id: sessionId,
        userId: userId,
        title: params.title,
        protocol: params.protocol,
        durationMinutes: params.durationMinutes,
        status: domain.FocusSessionStatus.active,
        ambientSound: params.ambientSound,
        startedAt: now,
        createdAt: now,
      );

      // Cache locally
      await _cacheFocusSession(session);

      // Try to sync to remote
      try {
        await _supabaseClient.from('focus_sessions').insert({
          'id': sessionId,
          'user_id': userId,
          'title': params.title,
          'protocol': params.protocol,
          'duration_minutes': params.durationMinutes,
          'ambient_sound': params.ambientSound,
          'status': 'active',
          'started_at': now.toIso8601String(),
        });
      } catch (e) {
        Logger.warning('Failed to sync session to remote, queued for sync');
        await _syncManager.addPendingOperation(
          entityType: 'focus_session',
          entityId: sessionId,
          operation: 'create',
          data: {
            'id': sessionId,
            'user_id': userId,
            'title': params.title,
            'protocol': params.protocol,
            'duration_minutes': params.durationMinutes,
            'ambient_sound': params.ambientSound,
            'status': 'active',
            'started_at': now.toIso8601String(),
          },
        );
      }

      return Right(session);
    } catch (e) {
      Logger.error('Failed to start focus session', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.FocusSession>> pauseSession(
    String sessionId,
  ) async {
    try {
      final cached = _cacheManager.getCachedFocusSession(sessionId);
      if (cached == null) {
        return const Left(ServerFailure(message: 'Session not found'));
      }

      final session = domain.FocusSession(
        id: cached.id,
        userId: cached.userId,
        title: cached.title,
        protocol: cached.protocol,
        durationMinutes: cached.durationMinutes,
        actualMinutes: cached.actualMinutes,
        status: domain.FocusSessionStatus.paused,
        score: cached.score,
        ambientSound: cached.ambientSound,
        distractionsCount: cached.distractionsCount,
        startedAt: cached.startedAt,
        endedAt: cached.endedAt,
        pausedAt: DateTime.now(),
        createdAt: cached.createdAt,
      );

      await _cacheFocusSession(session);

      // Sync to remote
      try {
        await _supabaseClient.from('focus_sessions').update({
          'status': 'paused',
          'paused_at': DateTime.now().toIso8601String(),
        }).eq('id', sessionId);
      } catch (e) {
        await _syncManager.addPendingOperation(
          entityType: 'focus_session',
          entityId: sessionId,
          operation: 'update',
          data: {
            'status': 'paused',
            'paused_at': DateTime.now().toIso8601String(),
          },
        );
      }

      return Right(session);
    } catch (e) {
      Logger.error('Failed to pause session', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.FocusSession>> resumeSession(
    String sessionId,
  ) async {
    try {
      final cached = _cacheManager.getCachedFocusSession(sessionId);
      if (cached == null) {
        return const Left(ServerFailure(message: 'Session not found'));
      }

      final session = domain.FocusSession(
        id: cached.id,
        userId: cached.userId,
        title: cached.title,
        protocol: cached.protocol,
        durationMinutes: cached.durationMinutes,
        actualMinutes: cached.actualMinutes,
        status: domain.FocusSessionStatus.active,
        score: cached.score,
        ambientSound: cached.ambientSound,
        distractionsCount: cached.distractionsCount,
        startedAt: cached.startedAt,
        endedAt: cached.endedAt,
        pausedAt: null,
        createdAt: cached.createdAt,
      );

      await _cacheFocusSession(session);

      // Sync to remote
      try {
        await _supabaseClient.from('focus_sessions').update({
          'status': 'active',
          'paused_at': null,
        }).eq('id', sessionId);
      } catch (e) {
        await _syncManager.addPendingOperation(
          entityType: 'focus_session',
          entityId: sessionId,
          operation: 'update',
          data: {
            'status': 'active',
            'paused_at': null,
          },
        );
      }

      return Right(session);
    } catch (e) {
      Logger.error('Failed to resume session', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.FocusSession>> endSession({
    required String sessionId,
    int? score,
    int? distractionsCount,
  }) async {
    try {
      final cached = _cacheManager.getCachedFocusSession(sessionId);
      if (cached == null) {
        return const Left(ServerFailure(message: 'Session not found'));
      }

      final now = DateTime.now();
      final actualMinutes = now.difference(cached.startedAt).inMinutes;

      final session = domain.FocusSession(
        id: cached.id,
        userId: cached.userId,
        title: cached.title,
        protocol: cached.protocol,
        durationMinutes: cached.durationMinutes,
        actualMinutes: actualMinutes,
        status: domain.FocusSessionStatus.completed,
        score: score,
        ambientSound: cached.ambientSound,
        distractionsCount: distractionsCount ?? cached.distractionsCount,
        startedAt: cached.startedAt,
        endedAt: now,
        createdAt: cached.createdAt,
      );

      await _cacheFocusSession(session);

      // Sync to remote
      try {
        await _supabaseClient.from('focus_sessions').update({
          'status': 'completed',
          'actual_minutes': actualMinutes,
          'score': score,
          'distractions_count': distractionsCount ?? cached.distractionsCount,
          'ended_at': now.toIso8601String(),
        }).eq('id', sessionId);
      } catch (e) {
        await _syncManager.addPendingOperation(
          entityType: 'focus_session',
          entityId: sessionId,
          operation: 'update',
          data: {
            'status': 'completed',
            'actual_minutes': actualMinutes,
            'score': score,
            'distractions_count': distractionsCount ?? cached.distractionsCount,
            'ended_at': now.toIso8601String(),
          },
        );
      }

      // Create behavioral log entry
      await _createBehavioralLog(
        userId: cached.userId,
        logType: 'focus',
        score: score,
        durationMinutes: actualMinutes,
        sessionId: sessionId,
      );

      return Right(session);
    } catch (e) {
      Logger.error('Failed to end session', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.FocusSession>> cancelSession(
    String sessionId,
  ) async {
    try {
      final cached = _cacheManager.getCachedFocusSession(sessionId);
      if (cached == null) {
        return const Left(ServerFailure(message: 'Session not found'));
      }

      final session = domain.FocusSession(
        id: cached.id,
        userId: cached.userId,
        title: cached.title,
        protocol: cached.protocol,
        durationMinutes: cached.durationMinutes,
        actualMinutes: cached.actualMinutes,
        status: domain.FocusSessionStatus.cancelled,
        score: cached.score,
        ambientSound: cached.ambientSound,
        distractionsCount: cached.distractionsCount,
        startedAt: cached.startedAt,
        endedAt: DateTime.now(),
        createdAt: cached.createdAt,
      );

      await _cacheFocusSession(session);

      // Sync to remote
      try {
        await _supabaseClient.from('focus_sessions').update({
          'status': 'cancelled',
          'ended_at': DateTime.now().toIso8601String(),
        }).eq('id', sessionId);
      } catch (e) {
        await _syncManager.addPendingOperation(
          entityType: 'focus_session',
          entityId: sessionId,
          operation: 'update',
          data: {
            'status': 'cancelled',
            'ended_at': DateTime.now().toIso8601String(),
          },
        );
      }

      return Right(session);
    } catch (e) {
      Logger.error('Failed to cancel session', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.FocusSession>> getSessionById(
    String sessionId,
  ) async {
    try {
      final cached = _cacheManager.getCachedFocusSession(sessionId);
      if (cached != null) {
        return Right(_convertToEntity(cached));
      }

      // Fetch from remote
      final response = await _supabaseClient
          .from('focus_sessions')
          .select()
          .eq('id', sessionId)
          .single();

      final session = _parseSession(response);
      await _cacheManager.cacheFocusSession(_convertToCache(session));

      return Right(session);
    } catch (e) {
      Logger.error('Failed to get session', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<domain.FocusSession>>> getSessions({
    required String userId,
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      // Get from cache first
      var sessions = _cacheManager.getCachedFocusSessionsByUser(userId);

      if (status != null) {
        sessions = sessions.where((s) => s.status == status).toList();
      }

      // Sort by startedAt descending
      sessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));

      if (limit != null) {
        sessions = sessions.take(limit).toList();
      }

      return Right(sessions.map(_convertToEntity).toList());
    } catch (e) {
      Logger.error('Failed to get sessions', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.FocusSession?>> getActiveSession(
    String userId,
  ) async {
    try {
      final sessions = _cacheManager.getCachedFocusSessionsByUser(userId);
      final activeSessions =
          sessions.where((s) => s.status == 'active').toList();

      if (activeSessions.isNotEmpty) {
        return Right(_convertToEntity(activeSessions.first));
      }

      return const Right(null);
    } catch (e) {
      Logger.error('Failed to get active session', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getSessionStats({
    required String userId,
  }) async {
    try {
      final sessions = _cacheManager.getCachedFocusSessionsByUser(userId);

      final completedSessions =
          sessions.where((s) => s.status == 'completed').toList();

      final totalMinutes = completedSessions.fold<int>(
        0,
        (sum, s) => sum + (s.actualMinutes ?? 0),
      );

      final avgScore = completedSessions.isNotEmpty
          ? completedSessions
                  .where((s) => s.score != null)
                  .fold<int>(0, (sum, s) => sum + s.score!) /
              completedSessions.where((s) => s.score != null).length
          : 0.0;

      return Right({
        'total_sessions': sessions.length,
        'completed_sessions': completedSessions.length,
        'total_minutes': totalMinutes,
        'total_hours': (totalMinutes / 60).toStringAsFixed(1),
        'average_score': avgScore.round(),
      });
    } catch (e) {
      Logger.error('Failed to get session stats', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Cache a focus session
  Future<void> _cacheFocusSession(domain.FocusSession session) async {
    final cacheSession = local.FocusSessionCache(
      id: session.id,
      userId: session.userId,
      title: session.title,
      protocol: session.protocol,
      durationMinutes: session.durationMinutes,
      actualMinutes: session.actualMinutes,
      status: session.status.name,
      score: session.score,
      ambientSound: session.ambientSound,
      distractionsCount: session.distractionsCount,
      startedAt: session.startedAt,
      endedAt: session.endedAt,
      pausedAt: session.pausedAt,
      createdAt: session.createdAt,
    );
    await _cacheManager.cacheFocusSession(cacheSession);
  }

  /// Convert cache model to entity
  domain.FocusSession _convertToEntity(local.FocusSessionCache cache) {
    return domain.FocusSession(
      id: cache.id,
      userId: cache.userId,
      title: cache.title,
      protocol: cache.protocol,
      durationMinutes: cache.durationMinutes,
      actualMinutes: cache.actualMinutes,
      status: domain.FocusSessionStatus.values.firstWhere(
        (s) => s.name == cache.status,
        orElse: () => domain.FocusSessionStatus.active,
      ),
      score: cache.score,
      ambientSound: cache.ambientSound,
      distractionsCount: cache.distractionsCount,
      startedAt: cache.startedAt,
      endedAt: cache.endedAt,
      pausedAt: cache.pausedAt,
      createdAt: cache.createdAt,
    );
  }

  /// Convert entity to cache model
  local.FocusSessionCache _convertToCache(domain.FocusSession session) {
    return local.FocusSessionCache(
      id: session.id,
      userId: session.userId,
      title: session.title,
      protocol: session.protocol,
      durationMinutes: session.durationMinutes,
      actualMinutes: session.actualMinutes,
      status: session.status.name,
      score: session.score,
      ambientSound: session.ambientSound,
      distractionsCount: session.distractionsCount,
      startedAt: session.startedAt,
      endedAt: session.endedAt,
      pausedAt: session.pausedAt,
      createdAt: session.createdAt,
    );
  }

  /// Parse session from Supabase response
  domain.FocusSession _parseSession(Map<String, dynamic> data) {
    return domain.FocusSession(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      title: data['title'] as String?,
      protocol: data['protocol'] as String?,
      durationMinutes: data['duration_minutes'] as int,
      actualMinutes: data['actual_minutes'] as int?,
      status: domain.FocusSessionStatus.values.firstWhere(
        (s) => s.name == data['status'],
        orElse: () => domain.FocusSessionStatus.active,
      ),
      score: data['score'] as int?,
      ambientSound: data['ambient_sound'] as String?,
      distractionsCount: data['distractions_count'] as int? ?? 0,
      startedAt: DateTime.parse(data['started_at'] as String),
      endedAt: data['ended_at'] != null
          ? DateTime.parse(data['ended_at'] as String)
          : null,
      createdAt: DateTime.parse(data['created_at'] as String),
    );
  }

  /// Create behavioral log entry
  Future<void> _createBehavioralLog({
    required String userId,
    required String logType,
    int? score,
    int? durationMinutes,
    String? sessionId,
  }) async {
    try {
      final logId = const Uuid().v4();
      final now = DateTime.now();

      final log = local.BehavioralLog(
        id: logId,
        userId: userId,
        logType: logType,
        score: score,
        durationMinutes: durationMinutes,
        metadata: {
          'session_id': sessionId,
          'type': 'focus_session',
        },
        recordedAt: now,
        createdAt: now,
      );

      await _cacheManager.cacheBehavioralLog(log);

      // Sync to remote
      try {
        await _supabaseClient.from('behavioral_logs').insert({
          'id': logId,
          'user_id': userId,
          'log_type': logType,
          'score': score,
          'duration_minutes': durationMinutes,
          'metadata': {
            'session_id': sessionId,
            'type': 'focus_session',
          },
          'recorded_at': now.toIso8601String(),
        });
      } catch (e) {
        await _syncManager.addPendingOperation(
          entityType: 'behavioral_log',
          entityId: logId,
          operation: 'create',
          data: {
            'id': logId,
            'user_id': userId,
            'log_type': logType,
            'score': score,
            'duration_minutes': durationMinutes,
            'metadata': {
              'session_id': sessionId,
              'type': 'focus_session',
            },
            'recorded_at': now.toIso8601String(),
          },
        );
      }
    } catch (e) {
      Logger.error('Failed to create behavioral log', error: e);
    }
  }
}
