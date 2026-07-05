import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/config/supabase_config.dart';

/// Focus Session Remote Data Source
class FocusSessionRemoteDataSource {
  final SupabaseClient _client;

  FocusSessionRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  Future<Map<String, dynamic>> startSession({
    required String userId,
    String? title,
    String? protocol,
    required int durationMinutes,
    String? ambientSound,
  }) async {
    final response = await _client
        .from('focus_sessions')
        .insert({
          'user_id': userId,
          'title': title,
          'protocol': protocol,
          'duration_minutes': durationMinutes,
          'ambient_sound': ambientSound,
          'status': 'active',
        })
        .select()
        .single();
    return response;
  }

  Future<Map<String, dynamic>> pauseSession(String sessionId) async {
    final response = await _client
        .from('focus_sessions')
        .update({'status': 'paused'})
        .eq('id', sessionId)
        .select()
        .single();
    return response;
  }

  Future<Map<String, dynamic>> resumeSession(String sessionId) async {
    final response = await _client
        .from('focus_sessions')
        .update({'status': 'active'})
        .eq('id', sessionId)
        .select()
        .single();
    return response;
  }

  Future<Map<String, dynamic>> endSession({
    required String sessionId,
    int? score,
    int? distractionsCount,
  }) async {
    final response = await _client
        .from('focus_sessions')
        .update({
          'status': 'completed',
          'ended_at': DateTime.now().toIso8601String(),
          'score': score,
          'distractions_count': distractionsCount,
        })
        .eq('id', sessionId)
        .select()
        .single();
    return response;
  }

  Future<Map<String, dynamic>> cancelSession(String sessionId) async {
    final response = await _client
        .from('focus_sessions')
        .update({
          'status': 'cancelled',
          'ended_at': DateTime.now().toIso8601String(),
        })
        .eq('id', sessionId)
        .select()
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getSessions({
    required String userId,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    var query = _client.from('focus_sessions').select().eq('user_id', userId);

    if (status != null) {
      query = query.eq('status', status);
    }
    if (startDate != null) {
      query = query.gte('started_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('started_at', endDate.toIso8601String());
    }

    final response = await query
        .order('started_at', ascending: false)
        .range(offset ?? 0, (offset ?? 0) + (limit ?? 50) - 1);
    return response;
  }

  Future<Map<String, dynamic>> getSessionById(String sessionId) async {
    final response = await _client
        .from('focus_sessions')
        .select()
        .eq('id', sessionId)
        .single();
    return response;
  }
}
