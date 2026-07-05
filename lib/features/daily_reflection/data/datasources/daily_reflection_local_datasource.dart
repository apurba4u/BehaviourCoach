import 'package:discipline_os/core/local/cache/cache_manager.dart';
import 'package:discipline_os/core/local/adapters/daily_reflection_adapter.dart'
    as local;

/// Daily Reflection Local Data Source
/// Handles all Hive cache operations for daily reflections
class DailyReflectionLocalDatasource {
  final CacheManager _cacheManager;

  DailyReflectionLocalDatasource({CacheManager? cacheManager})
      : _cacheManager = cacheManager ?? CacheManager.instance;

  /// Cache a daily reflection
  Future<void> cacheReflection(local.DailyReflection reflection) async {
    await _cacheManager.cacheDailyReflection(reflection);
  }

  /// Get a cached reflection by ID
  local.DailyReflection? getReflection(String reflectionId) {
    return _cacheManager.getCachedDailyReflection(reflectionId);
  }

  /// Get all cached reflections for a user
  List<local.DailyReflection> getReflectionsByUser(String userId) {
    return _cacheManager.getCachedDailyReflectionsByUser(userId);
  }

  /// Get cached reflections by user and type
  List<local.DailyReflection> getReflectionsByType(
    String userId,
    String reflectionType,
  ) {
    return _cacheManager.getCachedDailyReflectionsByType(
      userId,
      reflectionType,
    );
  }

  /// Cache all reflections
  Future<void> cacheAllReflections(
    List<local.DailyReflection> reflections,
  ) async {
    await _cacheManager.cacheAllDailyReflections(reflections);
  }

  /// Delete a cached reflection
  Future<void> deleteReflection(String reflectionId) async {
    final box = _cacheManager.dailyReflectionBox;
    await box.delete(reflectionId);
  }
}
