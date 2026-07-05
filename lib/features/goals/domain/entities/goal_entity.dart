import 'package:equatable/equatable.dart';

/// Goal Entity
class GoalEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final String? category;
  final int? targetValue;
  final int currentValue;
  final String? unit;
  final String status;
  final DateTime? deadline;
  final DateTime? completedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const GoalEntity({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    this.category,
    this.targetValue,
    this.currentValue = 0,
    this.unit,
    this.status = 'active',
    this.deadline,
    this.completedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        description,
        category,
        targetValue,
        currentValue,
        unit,
        status,
        deadline,
        completedAt,
        createdAt,
        updatedAt,
      ];
}
