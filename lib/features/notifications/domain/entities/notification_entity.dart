import 'package:equatable/equatable.dart';

/// Notification Entity
class NotificationEntity extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String? notificationType;
  final bool isRead;
  final String? actionUrl;
  final Map<String, dynamic> metadata;
  final DateTime? scheduledAt;
  final DateTime? sentAt;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.notificationType,
    this.isRead = false,
    this.actionUrl,
    this.metadata = const {},
    this.scheduledAt,
    this.sentAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        body,
        notificationType,
        isRead,
        actionUrl,
        metadata,
        scheduledAt,
        sentAt,
        createdAt,
      ];
}
