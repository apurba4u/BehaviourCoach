import 'package:equatable/equatable.dart';

/// Dashboard Data Entity - aggregates all dashboard information
class DashboardData extends Equatable {
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final String identityLevel;
  final int identityScore;
  final int disciplineScore;
  final int momentumScore;
  final int currentStreak;
  final int weeklyConsistency;
  final String? dailyInsightTitle;
  final String? dailyInsightContent;
  final String? dailyInsightTip;
  final List<DashboardGoal> todayGoals;
  final bool hasActiveFocusSession;
  final String? activeFocusSessionTitle;
  final int? activeFocusSessionMinutesRemaining;
  final DashboardReflection? recentReflection;
  final DateTime lastUpdated;

  const DashboardData({
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    this.identityLevel = 'novice',
    this.identityScore = 0,
    this.disciplineScore = 0,
    this.momentumScore = 0,
    this.currentStreak = 0,
    this.weeklyConsistency = 0,
    this.dailyInsightTitle,
    this.dailyInsightContent,
    this.dailyInsightTip,
    this.todayGoals = const [],
    this.hasActiveFocusSession = false,
    this.activeFocusSessionTitle,
    this.activeFocusSessionMinutesRemaining,
    this.recentReflection,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        userId,
        displayName,
        avatarUrl,
        identityLevel,
        identityScore,
        disciplineScore,
        momentumScore,
        currentStreak,
        weeklyConsistency,
        dailyInsightTitle,
        dailyInsightContent,
        dailyInsightTip,
        todayGoals,
        hasActiveFocusSession,
        activeFocusSessionTitle,
        activeFocusSessionMinutesRemaining,
        recentReflection,
        lastUpdated,
      ];
}

/// Dashboard Goal Item
class DashboardGoal extends Equatable {
  final String id;
  final String title;
  final int? targetValue;
  final int currentValue;
  final String? unit;
  final String status;

  const DashboardGoal({
    required this.id,
    required this.title,
    this.targetValue,
    this.currentValue = 0,
    this.unit,
    this.status = 'active',
  });

  double get progress => targetValue != null && targetValue! > 0
      ? (currentValue / targetValue!).clamp(0.0, 1.0)
      : 0.0;

  @override
  List<Object?> get props =>
      [id, title, targetValue, currentValue, unit, status];
}

/// Dashboard Reflection Summary
class DashboardReflection extends Equatable {
  final String id;
  final String mood;
  final int? energyLevel;
  final String? content;
  final DateTime recordedAt;

  const DashboardReflection({
    required this.id,
    required this.mood,
    this.energyLevel,
    this.content,
    required this.recordedAt,
  });

  @override
  List<Object?> get props => [id, mood, energyLevel, content, recordedAt];
}
