import 'package:equatable/equatable.dart';

/// Behavior Timeline Entity
class BehaviorTimelineEntity extends Equatable {
  final String id;
  final String userId;
  final String eventType;
  final String title;
  final String? description;
  final String? icon;
  final String? color;
  final Map<String, dynamic> metadata;
  final DateTime eventAt;
  final DateTime createdAt;

  const BehaviorTimelineEntity({
    required this.id,
    required this.userId,
    required this.eventType,
    required this.title,
    this.description,
    this.icon,
    this.color,
    this.metadata = const {},
    required this.eventAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        eventType,
        title,
        description,
        icon,
        color,
        metadata,
        eventAt,
        createdAt,
      ];
}
