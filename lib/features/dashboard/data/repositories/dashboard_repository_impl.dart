import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/core/local/cache/cache_manager.dart';
import 'package:discipline_os/core/local/adapters/behavioral_log_adapter.dart';
import 'package:discipline_os/core/local/adapters/user_profile_adapter.dart';
import 'package:discipline_os/core/utils/logger.dart';
import 'package:discipline_os/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:discipline_os/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Dashboard Repository Implementation
class DashboardRepositoryImpl implements DashboardRepository {
  final CacheManager _cacheManager;
  final SupabaseClient _supabaseClient;

  DashboardRepositoryImpl({
    CacheManager? cacheManager,
    SupabaseClient? supabaseClient,
  })  : _cacheManager = cacheManager ?? CacheManager.instance,
        _supabaseClient = supabaseClient ?? Supabase.instance.client;

  @override
  Future<Either<Failure, DashboardData>> getDashboardData(String userId) async {
    try {
      // Try to get cached data first
      final cachedData = _getFromCache(userId);
      if (cachedData != null) {
        return Right(cachedData);
      }

      // If no cache, fetch from remote
      return await _fetchFromRemote(userId);
    } catch (e) {
      Logger.error('Failed to get dashboard data', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, DashboardData>> refreshDashboardData(
    String userId,
  ) async {
    try {
      return await _fetchFromRemote(userId);
    } catch (e) {
      Logger.error('Failed to refresh dashboard data', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Get data from local cache
  DashboardData? _getFromCache(String userId) {
    final profile = _cacheManager.getCachedUserProfile(userId);
    if (profile == null) return null;

    final goals = _cacheManager.getCachedGoalsByUser(userId);
    final sessions = _cacheManager.getCachedFocusSessionsByUser(userId);
    final reflections = _cacheManager.getCachedDailyReflectionsByUser(userId);
    final insights = _cacheManager.getCachedAiInsightsByUser(userId);

    // Get active focus session
    final activeSessions = sessions.where((s) => s.status == 'active').toList();
    final activeSession =
        activeSessions.isNotEmpty ? activeSessions.first : null;

    // Get today's goals
    final todayGoals = goals
        .where((g) => g.status == 'active')
        .take(3)
        .map(
          (g) => DashboardGoal(
            id: g.id,
            title: g.title,
            targetValue: g.targetValue,
            currentValue: g.currentValue,
            unit: g.unit,
            status: g.status,
          ),
        )
        .toList();

    // Get recent reflection
    DashboardReflection? recentReflection;
    if (reflections.isNotEmpty) {
      reflections.sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
      final latest = reflections.first;
      recentReflection = DashboardReflection(
        id: latest.id,
        mood: latest.mood ?? 'neutral',
        energyLevel: latest.energyLevel,
        content: latest.content,
        recordedAt: latest.recordedAt,
      );
    }

    // Get daily insight
    String? insightTitle;
    String? insightContent;
    String? insightTip;
    if (insights.isNotEmpty) {
      final latestInsight = insights.first;
      insightTitle = latestInsight.title;
      insightContent = latestInsight.content;
    }

    // Calculate discipline score from recent logs
    final recentLogs = _cacheManager.getCachedBehavioralLogsByUser(userId);
    final disciplineScore = _calculateDisciplineScore(recentLogs);

    // Calculate momentum
    final momentumScore = _calculateMomentum(recentLogs);

    // Calculate streak
    final currentStreak = _calculateStreak(recentLogs);

    // Calculate weekly consistency
    final weeklyConsistency = _calculateWeeklyConsistency(recentLogs);

    return DashboardData(
      userId: userId,
      displayName: profile.displayName ?? 'User',
      avatarUrl: profile.avatarUrl,
      identityLevel: profile.identityLevel,
      identityScore: profile.identityScore,
      disciplineScore: disciplineScore,
      momentumScore: momentumScore,
      currentStreak: currentStreak,
      weeklyConsistency: weeklyConsistency,
      dailyInsightTitle: insightTitle,
      dailyInsightContent: insightContent,
      dailyInsightTip: insightTip,
      todayGoals: todayGoals,
      hasActiveFocusSession: activeSession != null,
      activeFocusSessionTitle: activeSession?.title,
      activeFocusSessionMinutesRemaining: activeSession != null
          ? (activeSession.durationMinutes -
              (DateTime.now().difference(activeSession.startedAt).inMinutes))
          : null,
      recentReflection: recentReflection,
      lastUpdated: DateTime.now(),
    );
  }

  /// Fetch data from remote Supabase
  Future<Either<Failure, DashboardData>> _fetchFromRemote(
    String userId,
  ) async {
    try {
      // Fetch all data in parallel
      final results = await Future.wait([
        _supabaseClient
            .from('user_profiles')
            .select()
            .eq('id', userId)
            .maybeSingle(),
        _supabaseClient
            .from('goals')
            .select()
            .eq('user_id', userId)
            .eq('status', 'active')
            .limit(3),
        _supabaseClient
            .from('focus_sessions')
            .select()
            .eq('user_id', userId)
            .eq('status', 'active')
            .maybeSingle(),
        _supabaseClient
            .from('daily_reflections')
            .select()
            .eq('user_id', userId)
            .order('recorded_at', ascending: false)
            .limit(1),
        _supabaseClient
            .from('ai_insights')
            .select()
            .eq('user_id', userId)
            .order('generated_at', ascending: false)
            .limit(1),
        _supabaseClient
            .from('behavioral_logs')
            .select()
            .eq('user_id', userId)
            .order('recorded_at', ascending: false)
            .limit(30),
      ]);

      final profileData = results[0] as Map<String, dynamic>?;
      final goalsData = results[1] as List<dynamic>;
      final activeSessionData = results[2] as Map<String, dynamic>?;
      final reflectionsData = results[3] as List<dynamic>;
      final insightsData = results[4] as List<dynamic>;
      final logsData = results[5] as List<dynamic>;

      if (profileData == null) {
        return const Left(ServerFailure(message: 'User profile not found'));
      }

      // Parse profile
      final profile = UserProfile(
        id: profileData['id'] as String,
        email: profileData['email'] as String? ?? '',
        displayName: profileData['display_name'] as String?,
        avatarUrl: profileData['avatar_url'] as String?,
        identityLevel: profileData['identity_level'] as String? ?? 'novice',
        identityScore: profileData['identity_score'] as int? ?? 0,
        timezone: profileData['timezone'] as String? ?? 'UTC',
        createdAt: DateTime.parse(profileData['created_at'] as String),
        updatedAt: DateTime.parse(profileData['updated_at'] as String),
      );

      // Cache profile
      await _cacheManager.cacheUserProfile(profile);

      // Parse goals
      final todayGoals = goalsData.map((g) {
        return DashboardGoal(
          id: g['id'] as String,
          title: g['title'] as String,
          targetValue: g['target_value'] as int?,
          currentValue: g['current_value'] as int? ?? 0,
          unit: g['unit'] as String?,
          status: g['status'] as String? ?? 'active',
        );
      }).toList();

      // Parse active session
      bool hasActiveSession = false;
      String? sessionTitle;
      int? sessionMinutesRemaining;

      if (activeSessionData != null) {
        hasActiveSession = true;
        sessionTitle = activeSessionData['title'] as String?;
        final startedAt = DateTime.parse(
          activeSessionData['started_at'] as String,
        );
        final duration = activeSessionData['duration_minutes'] as int;
        sessionMinutesRemaining =
            duration - DateTime.now().difference(startedAt).inMinutes;
      }

      // Parse reflection
      DashboardReflection? recentReflection;
      if (reflectionsData.isNotEmpty) {
        final r = reflectionsData.first;
        recentReflection = DashboardReflection(
          id: r['id'] as String,
          mood: r['mood'] as String? ?? 'neutral',
          energyLevel: r['energy_level'] as int?,
          content: r['content'] as String?,
          recordedAt: DateTime.parse(r['recorded_at'] as String),
        );
      }

      // Parse insight
      String? insightTitle;
      String? insightContent;
      if (insightsData.isNotEmpty) {
        final i = insightsData.first;
        insightTitle = i['title'] as String?;
        insightContent = i['content'] as String?;
      }

      // Parse logs for calculations
      final logs = logsData.map((l) {
        return BehavioralLog(
          id: l['id'] as String,
          userId: l['user_id'] as String,
          logType: l['log_type'] as String,
          score: l['score'] as int?,
          durationMinutes: l['duration_minutes'] as int?,
          metadata: l['metadata'] as Map<String, dynamic>? ?? {},
          recordedAt: DateTime.parse(l['recorded_at'] as String),
          createdAt: DateTime.parse(l['created_at'] as String),
        );
      }).toList();

      // Cache logs
      await _cacheManager.cacheAllBehavioralLogs(logs);

      // Calculate scores
      final disciplineScore = _calculateDisciplineScore(logs);
      final momentumScore = _calculateMomentum(logs);
      final currentStreak = _calculateStreak(logs);
      final weeklyConsistency = _calculateWeeklyConsistency(logs);

      return Right(DashboardData(
        userId: userId,
        displayName: profile.displayName ?? 'User',
        avatarUrl: profile.avatarUrl,
        identityLevel: profile.identityLevel,
        identityScore: profile.identityScore,
        disciplineScore: disciplineScore,
        momentumScore: momentumScore,
        currentStreak: currentStreak,
        weeklyConsistency: weeklyConsistency,
        dailyInsightTitle: insightTitle,
        dailyInsightContent: insightContent,
        todayGoals: todayGoals,
        hasActiveFocusSession: hasActiveSession,
        activeFocusSessionTitle: sessionTitle,
        activeFocusSessionMinutesRemaining: sessionMinutesRemaining,
        recentReflection: recentReflection,
        lastUpdated: DateTime.now(),
      ));
    } catch (e) {
      Logger.error('Failed to fetch dashboard data from remote', error: e);
      return Left(ServerFailure(message: e.toString()));
    }
  }

  /// Calculate discipline score from logs
  int _calculateDisciplineScore(List<BehavioralLog> logs) {
    if (logs.isEmpty) return 0;

    final scores =
        logs.where((l) => l.score != null).map((l) => l.score!).toList();

    if (scores.isEmpty) return 0;

    return (scores.reduce((a, b) => a + b) / scores.length).round();
  }

  /// Calculate momentum from recent logs
  int _calculateMomentum(List<BehavioralLog> logs) {
    if (logs.length < 2) return 0;

    final recentScores = logs
        .take(5)
        .where((l) => l.score != null)
        .map((l) => l.score!)
        .toList();

    if (recentScores.length < 2) return 0;

    final recentAvg =
        recentScores.reduce((a, b) => a + b) / recentScores.length;

    final olderScores = logs
        .skip(5)
        .take(5)
        .where((l) => l.score != null)
        .map((l) => l.score!)
        .toList();

    if (olderScores.isEmpty) return recentAvg.round();

    final olderAvg = olderScores.reduce((a, b) => a + b) / olderScores.length;

    return (recentAvg - olderAvg).round();
  }

  /// Calculate current streak
  int _calculateStreak(List<BehavioralLog> logs) {
    if (logs.isEmpty) return 0;

    final now = DateTime.now();
    var streak = 0;
    var currentDate = DateTime(now.year, now.month, now.day);

    for (var i = 0; i < 365; i++) {
      final hasLogForDate = logs.any((log) {
        final logDate = DateTime(
          log.recordedAt.year,
          log.recordedAt.month,
          log.recordedAt.day,
        );
        return logDate == currentDate;
      });

      if (hasLogForDate) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  /// Calculate weekly consistency
  int _calculateWeeklyConsistency(List<BehavioralLog> logs) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 7));

    final weekLogs = logs.where((log) {
      return log.recordedAt.isAfter(weekStart) &&
          log.recordedAt.isBefore(weekEnd);
    }).toList();

    final uniqueDays = weekLogs
        .map((log) => DateTime(
              log.recordedAt.year,
              log.recordedAt.month,
              log.recordedAt.day,
            ))
        .toSet()
        .length;

    return ((uniqueDays / 7) * 100).round();
  }
}
