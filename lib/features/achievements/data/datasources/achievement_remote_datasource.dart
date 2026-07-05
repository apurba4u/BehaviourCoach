import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/config/supabase_config.dart';

/// Achievement Remote Data Source
class AchievementRemoteDataSource {
  final SupabaseClient _client;

  AchievementRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  Future<Map<String, dynamic>> createAchievement({
    required String userId,
    required String achievementType,
    required String title,
    String? description,
    String? icon,
    String? color,
  }) async {
    final response = await _client
        .from('user_achievements')
        .insert({
          'user_id': userId,
          'achievement_type': achievementType,
          'title': title,
          'description': description,
          'icon': icon,
          'color': color,
        })
        .select()
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getAchievements({
    required String userId,
    String? achievementType,
    int? limit,
    int? offset,
  }) async {
    var query =
        _client.from('user_achievements').select().eq('user_id', userId);

    if (achievementType != null) {
      query = query.eq('achievement_type', achievementType);
    }

    final response = await query
        .order('unlocked_at', ascending: false)
        .range(offset ?? 0, (offset ?? 0) + (limit ?? 50) - 1);
    return response;
  }

  Future<Map<String, dynamic>> getAchievementById(String achievementId) async {
    final response = await _client
        .from('user_achievements')
        .select()
        .eq('id', achievementId)
        .single();
    return response;
  }
}
