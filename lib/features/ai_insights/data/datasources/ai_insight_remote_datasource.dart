import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/config/supabase_config.dart';

/// AI Insight Remote Data Source
class AiInsightRemoteDataSource {
  final SupabaseClient _client;

  AiInsightRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  Future<Map<String, dynamic>> createInsight({
    required String userId,
    required String insightType,
    required String title,
    required String content,
    double? confidenceScore,
    Map<String, dynamic>? metadata,
  }) async {
    final response = await _client
        .from('ai_insights')
        .insert({
          'user_id': userId,
          'insight_type': insightType,
          'title': title,
          'content': content,
          'confidence_score': confidenceScore,
          'metadata': metadata ?? {},
        })
        .select()
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getInsights({
    required String userId,
    String? insightType,
    bool? isRead,
    bool? isDismissed,
    int? limit,
    int? offset,
  }) async {
    var query = _client.from('ai_insights').select().eq('user_id', userId);

    if (insightType != null) {
      query = query.eq('insight_type', insightType);
    }
    if (isRead != null) {
      query = query.eq('is_read', isRead);
    }
    if (isDismissed != null) {
      query = query.eq('is_dismissed', isDismissed);
    }

    final response = await query
        .order('generated_at', ascending: false)
        .range(offset ?? 0, (offset ?? 0) + (limit ?? 50) - 1);
    return response;
  }

  Future<Map<String, dynamic>> getInsightById(String insightId) async {
    final response =
        await _client.from('ai_insights').select().eq('id', insightId).single();
    return response;
  }

  Future<Map<String, dynamic>> markAsRead(String insightId) async {
    final response = await _client
        .from('ai_insights')
        .update({'is_read': true})
        .eq('id', insightId)
        .select()
        .single();
    return response;
  }

  Future<Map<String, dynamic>> dismissInsight(String insightId) async {
    final response = await _client
        .from('ai_insights')
        .update({'is_dismissed': true})
        .eq('id', insightId)
        .select()
        .single();
    return response;
  }

  Future<void> deleteInsight(String insightId) async {
    await _client.from('ai_insights').delete().eq('id', insightId);
  }
}
