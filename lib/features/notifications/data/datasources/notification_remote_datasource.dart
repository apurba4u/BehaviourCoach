import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/config/supabase_config.dart';

/// Notification Remote Data Source
class NotificationRemoteDataSource {
  final SupabaseClient _client;

  NotificationRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  Future<Map<String, dynamic>> createNotification({
    required String userId,
    required String title,
    required String body,
    String? notificationType,
    String? actionUrl,
    Map<String, dynamic>? metadata,
    DateTime? scheduledAt,
  }) async {
    final response = await _client
        .from('notifications')
        .insert({
          'user_id': userId,
          'title': title,
          'body': body,
          'notification_type': notificationType,
          'action_url': actionUrl,
          'metadata': metadata ?? {},
          'scheduled_at': scheduledAt?.toIso8601String(),
        })
        .select()
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getNotifications({
    required String userId,
    bool? isRead,
    String? notificationType,
    int? limit,
    int? offset,
  }) async {
    var query = _client.from('notifications').select().eq('user_id', userId);

    if (isRead != null) {
      query = query.eq('is_read', isRead);
    }
    if (notificationType != null) {
      query = query.eq('notification_type', notificationType);
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(offset ?? 0, (offset ?? 0) + (limit ?? 50) - 1);
    return response;
  }

  Future<Map<String, dynamic>> markAsRead(String notificationId) async {
    final response = await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId)
        .select()
        .single();
    return response;
  }

  Future<void> markAllAsRead(String userId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  Future<void> deleteNotification(String notificationId) async {
    await _client.from('notifications').delete().eq('id', notificationId);
  }

  Future<void> deleteAllNotifications(String userId) async {
    await _client.from('notifications').delete().eq('user_id', userId);
  }
}
