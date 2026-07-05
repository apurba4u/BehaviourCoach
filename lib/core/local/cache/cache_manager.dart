import 'package:hive/hive.dart';
import 'package:discipline_os/core/local/hive_service.dart';
import 'package:discipline_os/core/local/adapters/ai_insight_adapter.dart';
import 'package:discipline_os/core/local/adapters/app_setting_adapter.dart';
import 'package:discipline_os/core/local/adapters/behavioral_log_adapter.dart';
import 'package:discipline_os/core/local/adapters/daily_reflection_adapter.dart';
import 'package:discipline_os/core/local/adapters/ai_coach_adapter.dart';
import 'package:discipline_os/core/local/adapters/focus_session_adapter.dart';
import 'package:discipline_os/core/local/adapters/goal_adapter.dart';
import 'package:discipline_os/core/local/adapters/user_profile_adapter.dart';
import 'package:discipline_os/core/utils/logger.dart';

/// Cache Manager - provides typed access to Hive boxes
class CacheManager {
  static CacheManager? _instance;
  final HiveService _hiveService;

  CacheManager._({required HiveService hiveService})
      : _hiveService = hiveService;

  static CacheManager get instance {
    _instance ??= CacheManager._(hiveService: HiveService.instance);
    return _instance!;
  }

  // User Profile Cache
  Box<UserProfile> get userProfileBox =>
      _hiveService.getBox<UserProfile>(HiveService.userProfileBox);

  // Behavioral Log Cache
  Box<BehavioralLog> get behavioralLogBox =>
      _hiveService.getBox<BehavioralLog>(HiveService.behavioralLogBox);

  // Daily Reflection Cache
  Box<DailyReflection> get dailyReflectionBox =>
      _hiveService.getBox<DailyReflection>(HiveService.dailyReflectionBox);

  // Goal Cache
  Box<Goal> get goalBox => _hiveService.getBox<Goal>(HiveService.goalBox);

  // Focus Session Cache
  Box<FocusSessionCache> get focusSessionBox =>
      _hiveService.getBox<FocusSessionCache>(HiveService.focusSessionBox);

  // AI Insight Cache
  Box<AiInsightCache> get aiInsightBox =>
      _hiveService.getBox<AiInsightCache>(HiveService.aiInsightBox);

  // App Setting Cache
  Box<AppSetting> get appSettingBox =>
      _hiveService.getBox<AppSetting>(HiveService.appSettingBox);

  // AI Coach Conversation Cache
  Box<AiCoachConversationCache> get aiCoachConversationBox =>
      _hiveService.getBox<AiCoachConversationCache>(
        HiveService.aiCoachConversationBox,
      );

  // User Profile Methods
  Future<void> cacheUserProfile(UserProfile profile) async {
    await userProfileBox.put(profile.id, profile);
    Logger.info('Cached user profile: ${profile.id}');
  }

  UserProfile? getCachedUserProfile(String userId) {
    return userProfileBox.get(userId);
  }

  List<UserProfile> getAllCachedUserProfiles() {
    return userProfileBox.values.toList();
  }

  Future<void> deleteUserProfile(String userId) async {
    await userProfileBox.delete(userId);
  }

  // Behavioral Log Methods
  Future<void> cacheBehavioralLog(BehavioralLog log) async {
    await behavioralLogBox.put(log.id, log);
  }

  BehavioralLog? getCachedBehavioralLog(String logId) {
    return behavioralLogBox.get(logId);
  }

  List<BehavioralLog> getCachedBehavioralLogsByUser(String userId) {
    return behavioralLogBox.values
        .where((BehavioralLog log) => log.userId == userId)
        .toList();
  }

  List<BehavioralLog> getCachedBehavioralLogsByType(
    String userId,
    String logType,
  ) {
    return behavioralLogBox.values
        .where(
          (BehavioralLog log) => log.userId == userId && log.logType == logType,
        )
        .toList();
  }

  // Daily Reflection Methods
  Future<void> cacheDailyReflection(DailyReflection reflection) async {
    await dailyReflectionBox.put(reflection.id, reflection);
  }

  DailyReflection? getCachedDailyReflection(String reflectionId) {
    return dailyReflectionBox.get(reflectionId);
  }

  List<DailyReflection> getCachedDailyReflectionsByUser(String userId) {
    return dailyReflectionBox.values
        .where((DailyReflection r) => r.userId == userId)
        .toList();
  }

  List<DailyReflection> getCachedDailyReflectionsByType(
    String userId,
    String reflectionType,
  ) {
    return dailyReflectionBox.values
        .where(
          (DailyReflection r) =>
              r.userId == userId && r.reflectionType == reflectionType,
        )
        .toList();
  }

  // Goal Methods
  Future<void> cacheGoal(Goal goal) async {
    await goalBox.put(goal.id, goal);
  }

  Goal? getCachedGoal(String goalId) {
    return goalBox.get(goalId);
  }

  List<Goal> getCachedGoalsByUser(String userId) {
    return goalBox.values.where((Goal g) => g.userId == userId).toList();
  }

  List<Goal> getCachedGoalsByStatus(String userId, String status) {
    return goalBox.values
        .where((Goal g) => g.userId == userId && g.status == status)
        .toList();
  }

  // Focus Session Methods
  Future<void> cacheFocusSession(FocusSessionCache session) async {
    await focusSessionBox.put(session.id, session);
  }

  FocusSessionCache? getCachedFocusSession(String sessionId) {
    return focusSessionBox.get(sessionId);
  }

  List<FocusSessionCache> getCachedFocusSessionsByUser(String userId) {
    return focusSessionBox.values
        .where((FocusSessionCache s) => s.userId == userId)
        .toList();
  }

  List<FocusSessionCache> getCachedFocusSessionsByStatus(
    String userId,
    String status,
  ) {
    return focusSessionBox.values
        .where(
            (FocusSessionCache s) => s.userId == userId && s.status == status)
        .toList();
  }

  // AI Insight Methods
  Future<void> cacheAiInsight(AiInsightCache insight) async {
    await aiInsightBox.put(insight.id, insight);
  }

  AiInsightCache? getCachedAiInsight(String insightId) {
    return aiInsightBox.get(insightId);
  }

  List<AiInsightCache> getCachedAiInsightsByUser(String userId) {
    return aiInsightBox.values
        .where((AiInsightCache i) => i.userId == userId)
        .toList();
  }

  List<AiInsightCache> getCachedUnreadAiInsights(String userId) {
    return aiInsightBox.values
        .where((AiInsightCache i) => i.userId == userId && !i.isRead)
        .toList();
  }

  // App Setting Methods
  Future<void> cacheAppSetting(AppSetting setting) async {
    final key = '${setting.userId}_${setting.settingKey}';
    await appSettingBox.put(key, setting);
  }

  AppSetting? getCachedAppSetting(String userId, String settingKey) {
    final key = '${userId}_$settingKey';
    return appSettingBox.get(key);
  }

  List<AppSetting> getCachedAppSettingsByUser(String userId) {
    return appSettingBox.values
        .where((AppSetting s) => s.userId == userId)
        .toList();
  }

  Future<void> deleteAppSetting(String userId, String settingKey) async {
    final key = '${userId}_$settingKey';
    await appSettingBox.delete(key);
  }

  // AI Coach Conversation Methods
  Future<void> cacheAiCoachConversation(
    AiCoachConversationCache conversation,
  ) async {
    await aiCoachConversationBox.put(conversation.id, conversation);
    Logger.info('Cached AI coach conversation: ${conversation.id}');
  }

  AiCoachConversationCache? getCachedAiCoachConversation(
    String conversationId,
  ) {
    return aiCoachConversationBox.get(conversationId);
  }

  List<AiCoachConversationCache> getCachedAiCoachConversationsByUser(
    String userId,
  ) {
    return aiCoachConversationBox.values
        .where((AiCoachConversationCache c) => c.userId == userId)
        .toList();
  }

  Future<void> deleteAiCoachConversation(String conversationId) async {
    await aiCoachConversationBox.delete(conversationId);
  }

  // Bulk Operations
  Future<void> cacheAllUserProfiles(List<UserProfile> profiles) async {
    final map = <String, UserProfile>{};
    for (final profile in profiles) {
      map[profile.id] = profile;
    }
    await userProfileBox.putAll(map);
  }

  Future<void> cacheAllBehavioralLogs(List<BehavioralLog> logs) async {
    final map = <String, BehavioralLog>{};
    for (final log in logs) {
      map[log.id] = log;
    }
    await behavioralLogBox.putAll(map);
  }

  Future<void> cacheAllDailyReflections(
    List<DailyReflection> reflections,
  ) async {
    final map = <String, DailyReflection>{};
    for (final reflection in reflections) {
      map[reflection.id] = reflection;
    }
    await dailyReflectionBox.putAll(map);
  }

  Future<void> cacheAllGoals(List<Goal> goals) async {
    final map = <String, Goal>{};
    for (final goal in goals) {
      map[goal.id] = goal;
    }
    await goalBox.putAll(map);
  }

  Future<void> cacheAllFocusSessions(List<FocusSessionCache> sessions) async {
    final map = <String, FocusSessionCache>{};
    for (final session in sessions) {
      map[session.id] = session;
    }
    await focusSessionBox.putAll(map);
  }

  Future<void> cacheAllAiInsights(List<AiInsightCache> insights) async {
    final map = <String, AiInsightCache>{};
    for (final insight in insights) {
      map[insight.id] = insight;
    }
    await aiInsightBox.putAll(map);
  }

  Future<void> cacheAllAiCoachConversations(
    List<AiCoachConversationCache> conversations,
  ) async {
    final map = <String, AiCoachConversationCache>{};
    for (final conversation in conversations) {
      map[conversation.id] = conversation;
    }
    await aiCoachConversationBox.putAll(map);
  }
}
