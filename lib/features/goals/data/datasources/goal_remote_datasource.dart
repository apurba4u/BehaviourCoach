import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/config/supabase_config.dart';

/// Goal Remote Data Source
class GoalRemoteDataSource {
  final SupabaseClient _client;

  GoalRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  Future<Map<String, dynamic>> createGoal({
    required String userId,
    required String title,
    String? description,
    String? category,
    int? targetValue,
    String? unit,
    DateTime? deadline,
  }) async {
    final response = await _client
        .from('goals')
        .insert({
          'user_id': userId,
          'title': title,
          'description': description,
          'category': category,
          'target_value': targetValue,
          'unit': unit,
          'deadline': deadline?.toIso8601String(),
        })
        .select()
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getGoals({
    required String userId,
    String? status,
    String? category,
    int? limit,
    int? offset,
  }) async {
    var query = _client.from('goals').select().eq('user_id', userId);

    if (status != null) {
      query = query.eq('status', status);
    }
    if (category != null) {
      query = query.eq('category', category);
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(offset ?? 0, (offset ?? 0) + (limit ?? 50) - 1);
    return response;
  }

  Future<Map<String, dynamic>> getGoalById(String goalId) async {
    final response =
        await _client.from('goals').select().eq('id', goalId).single();
    return response;
  }

  Future<Map<String, dynamic>> updateGoal({
    required String goalId,
    String? title,
    String? description,
    String? category,
    int? targetValue,
    int? currentValue,
    String? unit,
    String? status,
    DateTime? deadline,
  }) async {
    final updates = <String, dynamic>{};
    if (title != null) updates['title'] = title;
    if (description != null) updates['description'] = description;
    if (category != null) updates['category'] = category;
    if (targetValue != null) updates['target_value'] = targetValue;
    if (currentValue != null) updates['current_value'] = currentValue;
    if (unit != null) updates['unit'] = unit;
    if (status != null) updates['status'] = status;
    if (deadline != null) updates['deadline'] = deadline.toIso8601String();
    if (status == 'completed') {
      updates['completed_at'] = DateTime.now().toIso8601String();
    }

    final response = await _client
        .from('goals')
        .update(updates)
        .eq('id', goalId)
        .select()
        .single();
    return response;
  }

  Future<void> deleteGoal(String goalId) async {
    await _client.from('goals').delete().eq('id', goalId);
  }
}
