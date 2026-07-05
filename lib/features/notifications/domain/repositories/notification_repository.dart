import 'package:dartz/dartz.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/notifications/domain/entities/notification_entity.dart';

/// Notification Repository Interface
abstract class NotificationRepository {
  Future<Either<Failure, NotificationEntity>> createNotification({
    required String userId,
    required String title,
    required String body,
    String? notificationType,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    DateTime? scheduledAt,
  });

  Future<Either<Failure, List<NotificationEntity>>> getNotifications({
    required String userId,
    bool? isRead,
    String? notificationType,
    int? limit,
    int? offset,
  });

  Future<Either<Failure, NotificationEntity>> markAsRead(String notificationId);

  Future<Either<Failure, Unit>> markAllAsRead(String userId);

  Future<Either<Failure, Unit>> deleteNotification(String notificationId);

  Future<Either<Failure, Unit>> deleteAllNotifications(String userId);
}
