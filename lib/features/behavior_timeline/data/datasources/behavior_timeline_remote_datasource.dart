import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/config/supabase_config.dart';

/// Behavior Timeline Remote Data Source
class BehaviorTimelineRemoteDataSource {
  final SupabaseClient _client;

  BehaviorTimelineRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  Future<Map<String, dynamic>> createEvent({
    required String userId,
    required String eventType,
    required String title,
    String? description,
    String? icon,
    String? color,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _client
        .from('behavior_timeline')
        .insert({
          'user_id': userId,
          'event_type': eventType,
          'title': title,
          'description': description,
          'icon': icon,
          'color': color,
          'metadata': metadata ?? {},
        })
        .select()
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getEvents({
    required String userId,
    String? eventType,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    var query = _client
        .from('behavior_timeline')
        .select()
        .eq('user_id', userId);

    if (eventType != null) {
      query = query.eq('event_type', eventType);
    }
    if (startDate != null) {
      query = query.gte('event_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('event_at', endDate.toIso8601String());
    }

    final response = await query
        .order('event_at', ascending: false)
        .range(offset ?? 0, (offset ?? 0) + (limit ?? 50) - 1);
    return response;
  }

  Future<Map<String, dynamic>> getEventById(String eventId) async {
    final response = await _client
        .from('behavior_timeline')
        .select()
        .eq('id', eventId)
        .single();
    return response;
  }

  Future<void> deleteEvent(String eventId) async {
    await _client.from('behavior_timeline').delete().eq('id', eventId);
  }
}
