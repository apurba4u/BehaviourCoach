import 'package:hive_flutter/hive_flutter.dart';
import 'package:discipline_os/core/local/adapters/ai_insight_adapter.dart';
import 'package:discipline_os/core/local/adapters/app_setting_adapter.dart';
import 'package:discipline_os/core/local/adapters/behavioral_log_adapter.dart';
import 'package:discipline_os/core/local/adapters/daily_reflection_adapter.dart';
import 'package:discipline_os/core/local/adapters/focus_session_adapter.dart';
import 'package:discipline_os/core/local/adapters/goal_adapter.dart';
import 'package:discipline_os/core/local/adapters/pending_operation_adapter.dart';
import 'package:discipline_os/core/local/adapters/user_profile_adapter.dart';
import 'package:discipline_os/core/utils/logger.dart';

/// Hive Service - manages local storage initialization and access
class HiveService {
  static HiveService? _instance;
  static bool _initialized = false;

  HiveService._();

  static HiveService get instance {
    _instance ??= HiveService._();
    return _instance!;
  }

  /// Box names
  static const String userProfileBox = 'user_profiles';
  static const String behavioralLogBox = 'behavioral_logs';
  static const String dailyReflectionBox = 'daily_reflections';
  static const String goalBox = 'goals';
  static const String focusSessionBox = 'focus_sessions';
  static const String aiInsightBox = 'ai_insights';
  static const String appSettingBox = 'app_settings';
  static const String pendingOperationBox = 'pending_operations';

  /// Initialize Hive with all adapters
  Future<void> init() async {
    if (_initialized) return;

    try {
      await Hive.initFlutter();

      // Register adapters
      Hive
        ..registerAdapter(UserProfileAdapter())
        ..registerAdapter(BehavioralLogAdapter())
        ..registerAdapter(DailyReflectionAdapter())
        ..registerAdapter(GoalAdapter())
        ..registerAdapter(FocusSessionAdapter())
        ..registerAdapter(AiInsightAdapter())
        ..registerAdapter(AppSettingAdapter())
        ..registerAdapter(PendingOperationAdapter());

      // Open boxes
      await Future.wait([
        Hive.openBox<UserProfile>(userProfileBox),
        Hive.openBox<BehavioralLog>(behavioralLogBox),
        Hive.openBox<DailyReflection>(dailyReflectionBox),
        Hive.openBox<Goal>(goalBox),
        Hive.openBox<FocusSession>(focusSessionBox),
        Hive.openBox<AiInsightCache>(aiInsightBox),
        Hive.openBox<AppSetting>(appSettingBox),
        Hive.openBox<PendingOperation>(pendingOperationBox),
      ]);

      _initialized = true;
      Logger.info('Hive initialized successfully');
    } catch (e) {
      Logger.error('Failed to initialize Hive', error: e);
      rethrow;
    }
  }

  /// Get box by type
  Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  /// Close all boxes
  Future<void> closeAll() async {
    await Hive.close();
    _initialized = false;
  }

  /// Clear all data
  Future<void> clearAll() async {
    await Future.wait([
      Hive.box<UserProfile>(userProfileBox).clear(),
      Hive.box<BehavioralLog>(behavioralLogBox).clear(),
      Hive.box<DailyReflection>(dailyReflectionBox).clear(),
      Hive.box<Goal>(goalBox).clear(),
      Hive.box<FocusSession>(focusSessionBox).clear(),
      Hive.box<AiInsightCache>(aiInsightBox).clear(),
      Hive.box<AppSetting>(appSettingBox).clear(),
      Hive.box<PendingOperation>(pendingOperationBox).clear(),
    ]);
  }
}
