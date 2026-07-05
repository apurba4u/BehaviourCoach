import 'package:equatable/equatable.dart';

/// Achievement Entity
class AchievementEntity extends Equatable {
  final String id;
  final String userId;
  final String achievementType;
  final String title;
  final String? description;
  final String? icon;
  final String? color;
  final DateTime unlockedAt;
  final DateTime createdAt;

  const AchievementEntity({
    required this.id,
    required this.userId,
    required this.achievementType,
    required this.title,
    this.description,
    this.icon,
    this.color,
    required this.unlockedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        achievementType,
        title,
        description,
        icon,
        color,
        unlockedAt,
        createdAt,
      ];
}
