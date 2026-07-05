import 'package:discipline_os/core/utils/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Daily Reflection Remote Data Source
/// Handles all Supabase operations for daily reflections
class DailyReflectionRemoteDatasource {
  final SupabaseClient _supabaseClient;

  DailyReflectionRemoteDatasource({SupabaseClient? supabaseClient})
      : _supabaseClient = supabaseClient ?? Supabase.instance.client;

  /// Insert a new daily reflection
  Future<Map<String, dynamic>> createReflection({
    required String id,
    required String userId,
    required String reflectionType,
    String? mood,
    int? energyLevel,
    String? content,
    String? voiceUrl,
    required DateTime recordedAt,
  }) async {
    final response = await _supabaseClient
        .from('daily_reflections')
        .insert({
          'id': id,
          'user_id': userId,
          'reflection_type': reflectionType,
          'mood': mood,
          'energy_level': energyLevel,
          'content': content,
          'voice_url': voiceUrl,
          'recorded_at': recordedAt.toIso8601String(),
        })
        .select()
        .single();

    Logger.info('Created daily reflection remotely: $id');
    return response;
  }

  /// Get a reflection by ID
  Future<Map<String, dynamic>> getReflectionById(String reflectionId) async {
    final response = await _supabaseClient
        .from('daily_reflections')
        .select()
        .eq('id', reflectionId)
        .single();

    return response;
  }

  /// Get reflections for a user
  Future<List<Map<String, dynamic>>> getReflections({
    required String userId,
    String? reflectionType,
    int? limit,
    int? offset,
  }) async {
    var query = _supabaseClient
        .from('daily_reflections')
        .select()
        .eq('user_id', userId);

    if (reflectionType != null) {
      query = query.eq('reflection_type', reflectionType);
    }

    var orderedQuery = query.order('recorded_at', ascending: false);

    if (offset != null && limit != null) {
      orderedQuery = orderedQuery.range(offset, offset + limit - 1);
    } else if (limit != null) {
      orderedQuery = orderedQuery.limit(limit);
    }

    final response = await orderedQuery;
    return List<Map<String, dynamic>>.from(response);
  }

  /// Update a reflection
  Future<Map<String, dynamic>> updateReflection({
    required String id,
    String? mood,
    int? energyLevel,
    String? content,
    String? voiceUrl,
    String? aiSynthesis,
  }) async {
    final updateData = <String, dynamic>{
      'updated_at': DateTime.now().toIso8601String(),
    };

    if (mood != null) updateData['mood'] = mood;
    if (energyLevel != null) updateData['energy_level'] = energyLevel;
    if (content != null) updateData['content'] = content;
    if (voiceUrl != null) updateData['voice_url'] = voiceUrl;
    if (aiSynthesis != null) updateData['ai_synthesis'] = aiSynthesis;

    final response = await _supabaseClient
        .from('daily_reflections')
        .update(updateData)
        .eq('id', id)
        .select()
        .single();

    Logger.info('Updated daily reflection remotely: $id');
    return response;
  }

  /// Delete a reflection
  Future<void> deleteReflection(String reflectionId) async {
    await _supabaseClient
        .from('daily_reflections')
        .delete()
        .eq('id', reflectionId);

    Logger.info('Deleted daily reflection remotely: $reflectionId');
  }

  /// Get reflections by date range
  Future<List<Map<String, dynamic>>> getReflectionsByDateRange({
    required String userId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _supabaseClient
        .from('daily_reflections')
        .select()
        .eq('user_id', userId)
        .gte('recorded_at', startDate.toIso8601String())
        .lte('recorded_at', endDate.toIso8601String())
        .order('recorded_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
