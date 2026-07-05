import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/config/supabase_config.dart';

/// Behavioral Log Remote Data Source
class BehavioralLogRemoteDataSource {
  final SupabaseClient _client;

  BehavioralLogRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  Future<Map<String, dynamic>> createLog({
    required String userId,
    required String logType,
    int? score,
    int? durationMinutes,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _client
        .from('behavioral_logs')
        .insert({
          'user_id': userId,
          'log_type': logType,
          'score': score,
          'duration_minutes': durationMinutes,
          'metadata': metadata ?? {},
        })
        .select()
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getLogs({
    required String userId,
    String? logType,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    var query = _client.from('behavioral_logs').select().eq('user_id', userId);

    if (logType != null) {
      query = query.eq('log_type', logType);
    }
    if (startDate != null) {
      query = query.gte('recorded_at', startDate.toIso8601String());
    }
    if (endDate != null) {
      query = query.lte('recorded_at', endDate.toIso8601String());
    }

    final response = await query
        .order('recorded_at', ascending: false)
        .range(offset ?? 0, (offset ?? 0) + (limit ?? 50) - 1);
    return response;
  }

  Future<Map<String, dynamic>> getLogById(String logId) async {
    final response =
        await _client.from('behavioral_logs').select().eq('id', logId).single();
    return response;
  }

  Future<Map<String, dynamic>> updateLog({
    required String logId,
    int? score,
    int? durationMinutes,
    Map<String, dynamic>? metadata,
  }) async {
    final updates = <String, dynamic>{};
    if (score != null) updates['score'] = score;
    if (durationMinutes != null) updates['duration_minutes'] = durationMinutes;
    if (metadata != null) updates['metadata'] = metadata;

    final response = await _client
        .from('behavioral_logs')
        .update(updates)
        .eq('id', logId)
        .select()
        .single();
    return response;
  }

  Future<void> deleteLog(String logId) async {
    await _client.from('behavioral_logs').delete().eq('id', logId);
  }
}
