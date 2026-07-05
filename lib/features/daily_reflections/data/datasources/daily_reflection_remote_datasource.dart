import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/config/supabase_config.dart';

/// Daily Reflection Remote Data Source
class DailyReflectionRemoteDataSource {
  final SupabaseClient _client;

  DailyReflectionRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  Future<Map<String, dynamic>> createReflection({
    required String userId,
    required String reflectionType,
    String? mood,
    int? energyLevel,
    String? content,
    String? voiceUrl,
  }) async {
    final response = await _client
        .from('daily_reflections')
        .insert({
          'user_id': userId,
          'reflection_type': reflectionType,
          'mood': mood,
          'energy_level': energyLevel,
          'content': content,
          'voice_url': voiceUrl,
        })
        .select()
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getReflections({
    required String userId,
    String? reflectionType,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) async {
    var query = _client
        .from('daily_reflections')
        .select()
        .eq('user_id', userId);

    if (reflectionType != null) {
      query = query.eq('reflection_type', reflectionType);
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

  Future<Map<String, dynamic>> getReflectionById(String reflectionId) async {
    final response = await _client
        .from('daily_reflections')
        .select()
        .eq('id', reflectionId)
        .single();
    return response;
  }

  Future<Map<String, dynamic>> updateReflection({
    required String reflectionId,
    String? mood,
    int? energyLevel,
    String? content,
    String? voiceUrl,
    String? aiSynthesis,
  }) async {
    final updates = <String, dynamic>{};
    if (mood != null) updates['mood'] = mood;
    if (energyLevel != null) updates['energy_level'] = energyLevel;
    if (content != null) updates['content'] = content;
    if (voiceUrl != null) updates['voice_url'] = voiceUrl;
    if (aiSynthesis != null) updates['ai_synthesis'] = aiSynthesis;

    final response = await _client
        .from('daily_reflections')
        .update(updates)
        .eq('id', reflectionId)
        .select()
        .single();
    return response;
  }

  Future<void> deleteReflection(String reflectionId) async {
    await _client.from('daily_reflections').delete().eq('id', reflectionId);
  }
}
