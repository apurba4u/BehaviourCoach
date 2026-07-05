import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/core/local/adapters/daily_reflection_adapter.dart'
    as local;
import 'package:discipline_os/core/sync/sync_manager.dart';
import 'package:discipline_os/core/utils/logger.dart';
import 'package:discipline_os/features/daily_reflection/domain/entities/daily_reflection_entity.dart'
    as domain;
import 'package:discipline_os/features/daily_reflection/domain/repositories/daily_reflection_repository.dart';
import 'package:discipline_os/features/daily_reflection/data/datasources/daily_reflection_local_datasource.dart';
import 'package:discipline_os/features/daily_reflection/data/datasources/daily_reflection_remote_datasource.dart';
import 'package:uuid/uuid.dart';

/// Daily Reflection Repository Implementation
class DailyReflectionRepositoryImpl implements DailyReflectionRepository {
  final DailyReflectionLocalDatasource _localDatasource;
  final DailyReflectionRemoteDatasource _remoteDatasource;
  final SyncManager _syncManager;

  DailyReflectionRepositoryImpl({
    DailyReflectionLocalDatasource? localDatasource,
    DailyReflectionRemoteDatasource? remoteDatasource,
    SyncManager? syncManager,
  })  : _localDatasource = localDatasource ?? DailyReflectionLocalDatasource(),
        _remoteDatasource =
            remoteDatasource ?? DailyReflectionRemoteDatasource(),
        _syncManager = syncManager ?? SyncManager.instance;

  @override
  Future<Either<Failure, domain.DailyReflectionEntity>> createReflection({
    required String userId,
    required domain.CreateReflectionParams params,
  }) async {
    try {
      final reflectionId = const Uuid().v4();
      final now = DateTime.now();

      final entity = domain.DailyReflectionEntity(
        id: reflectionId,
        userId: userId,
        reflectionType: params.reflectionType,
        mood: params.mood,
        energyLevel: params.energyLevel,
        content: params.content,
        voiceUrl: params.voiceUrl,
        recordedAt: params.recordedAt ?? now,
        createdAt: now,
        updatedAt: now,
      );

      // Cache locally
      await _cacheReflection(entity);

      // Try to sync to remote
      try {
        await _remoteDatasource.createReflection(
          id: reflectionId,
          userId: userId,
          reflectionType: params.reflectionType.value,
          mood: params.mood,
          energyLevel: params.energyLevel,
          content: params.content,
          voiceUrl: params.voiceUrl,
          recordedAt: params.recordedAt ?? now,
        );
      } catch (e) {
        Logger.warning('Failed to sync reflection to remote, queued for sync');
        await _syncManager.addPendingOperation(
          entityType: 'daily_reflection',
          entityId: reflectionId,
          operation: 'create',
          data: {
            'id': reflectionId,
            'user_id': userId,
            'reflection_type': params.reflectionType.value,
            'mood': params.mood,
            'energy_level': params.energyLevel,
            'content': params.content,
            'voice_url': params.voiceUrl,
            'recorded_at': (params.recordedAt ?? now).toIso8601String(),
          },
        );
      }

      return Right(entity);
    } catch (e) {
      Logger.error('Failed to create daily reflection', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.DailyReflectionEntity>> getReflectionById(
    String reflectionId,
  ) async {
    try {
      // Check cache first
      final cached = _localDatasource.getReflection(reflectionId);
      if (cached != null) {
        return Right(_convertToEntity(cached));
      }

      // Fetch from remote
      final response = await _remoteDatasource.getReflectionById(reflectionId);
      final entity = _parseReflection(response);

      // Cache the result
      await _cacheReflection(entity);

      return Right(entity);
    } catch (e) {
      Logger.error('Failed to get daily reflection', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<domain.DailyReflectionEntity>>> getReflections({
    required String userId,
    domain.ReflectionType? reflectionType,
    int? limit,
    int? offset,
  }) async {
    try {
      // Get from cache first
      var cached = _localDatasource.getReflectionsByUser(userId);

      if (reflectionType != null) {
        cached = cached
            .where((r) => r.reflectionType == reflectionType.value)
            .toList();
      }

      // Sort by recordedAt descending
      cached.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

      if (limit != null) {
        cached = cached.take(limit).toList();
      }

      return Right(cached.map(_convertToEntity).toList());
    } catch (e) {
      Logger.error('Failed to get daily reflections', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, domain.DailyReflectionEntity>> updateReflection({
    required domain.UpdateReflectionParams params,
  }) async {
    try {
      final cached = _localDatasource.getReflection(params.id);
      if (cached == null) {
        return const Left(ServerFailure(message: 'Reflection not found'));
      }

      final now = DateTime.now();
      final entity = domain.DailyReflectionEntity(
        id: cached.id,
        userId: cached.userId,
        reflectionType: domain.ReflectionType.values.firstWhere(
          (t) => t.value == cached.reflectionType,
          orElse: () => domain.ReflectionType.morning,
        ),
        mood: params.mood ?? cached.mood,
        energyLevel: params.energyLevel ?? cached.energyLevel,
        content: params.content ?? cached.content,
        voiceUrl: params.voiceUrl ?? cached.voiceUrl,
        aiSynthesis: params.aiSynthesis ?? cached.aiSynthesis,
        recordedAt: cached.recordedAt,
        createdAt: cached.createdAt,
        updatedAt: now,
      );

      await _cacheReflection(entity);

      // Sync to remote
      try {
        await _remoteDatasource.updateReflection(
          id: params.id,
          mood: params.mood,
          energyLevel: params.energyLevel,
          content: params.content,
          voiceUrl: params.voiceUrl,
          aiSynthesis: params.aiSynthesis,
        );
      } catch (e) {
        await _syncManager.addPendingOperation(
          entityType: 'daily_reflection',
          entityId: params.id,
          operation: 'update',
          data: {
            if (params.mood != null) 'mood': params.mood,
            if (params.energyLevel != null) 'energy_level': params.energyLevel,
            if (params.content != null) 'content': params.content,
            if (params.voiceUrl != null) 'voice_url': params.voiceUrl,
            if (params.aiSynthesis != null) 'ai_synthesis': params.aiSynthesis,
          },
        );
      }

      return Right(entity);
    } catch (e) {
      Logger.error('Failed to update daily reflection', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReflection(String reflectionId) async {
    try {
      await _localDatasource.deleteReflection(reflectionId);

      // Sync to remote
      try {
        await _remoteDatasource.deleteReflection(reflectionId);
      } catch (e) {
        await _syncManager.addPendingOperation(
          entityType: 'daily_reflection',
          entityId: reflectionId,
          operation: 'delete',
        );
      }

      return const Right(null);
    } catch (e) {
      Logger.error('Failed to delete daily reflection', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<domain.DailyReflectionEntity>>>
      getReflectionsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final cached = _localDatasource.getReflectionsByUser(userId);
      final filtered = cached
          .where((r) =>
              r.recordedAt.isAfter(startDate) && r.recordedAt.isBefore(endDate))
          .toList()
        ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));

      return Right(filtered.map(_convertToEntity).toList());
    } catch (e) {
      Logger.error('Failed to get reflections by date range', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Cache a daily reflection
  Future<void> _cacheReflection(domain.DailyReflectionEntity entity) async {
    final cacheReflection = local.DailyReflection(
      id: entity.id,
      userId: entity.userId,
      reflectionType: entity.reflectionType.value,
      mood: entity.mood,
      energyLevel: entity.energyLevel,
      content: entity.content,
      voiceUrl: entity.voiceUrl,
      aiSynthesis: entity.aiSynthesis,
      recordedAt: entity.recordedAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
    await _localDatasource.cacheReflection(cacheReflection);
  }

  /// Convert cache model to domain entity
  domain.DailyReflectionEntity _convertToEntity(local.DailyReflection cache) {
    return domain.DailyReflectionEntity(
      id: cache.id,
      userId: cache.userId,
      reflectionType: domain.ReflectionType.values.firstWhere(
        (t) => t.value == cache.reflectionType,
        orElse: () => domain.ReflectionType.morning,
      ),
      mood: cache.mood,
      energyLevel: cache.energyLevel,
      content: cache.content,
      voiceUrl: cache.voiceUrl,
      aiSynthesis: cache.aiSynthesis,
      recordedAt: cache.recordedAt,
      createdAt: cache.createdAt,
      updatedAt: cache.updatedAt,
    );
  }

  /// Parse reflection from Supabase response
  domain.DailyReflectionEntity _parseReflection(Map<String, dynamic> data) {
    return domain.DailyReflectionEntity(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      reflectionType: domain.ReflectionType.values.firstWhere(
        (t) => t.value == data['reflection_type'],
        orElse: () => domain.ReflectionType.morning,
      ),
      mood: data['mood'] as String?,
      energyLevel: data['energy_level'] as int?,
      content: data['content'] as String?,
      voiceUrl: data['voice_url'] as String?,
      aiSynthesis: data['ai_synthesis'] as String?,
      recordedAt: DateTime.parse(data['recorded_at'] as String),
      createdAt: DateTime.parse(data['created_at'] as String),
      updatedAt: DateTime.parse(data['updated_at'] as String),
    );
  }
}
