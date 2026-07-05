import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/config/supabase_config.dart';

/// User Profile Remote Data Source
class UserProfileRemoteDataSource {
  final SupabaseClient _client;

  UserProfileRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  Future<Map<String, dynamic>> getProfile(String userId) async {
    final response = await _client
        .from('user_profiles')
        .select()
        .eq('id', userId)
        .single();
    return response;
  }

  Future<Map<String, dynamic>> updateProfile({
    required String userId,
    String? displayName,
    String? avatarUrl,
    String? identityLevel,
    int? identityScore,
  }) async {
    final updates = <String, dynamic>{};
    if (displayName != null) updates['display_name'] = displayName;
    if (avatarUrl != null) updates['avatar_url'] = avatarUrl;
    if (identityLevel != null) updates['identity_level'] = identityLevel;
    if (identityScore != null) updates['identity_score'] = identityScore;

    final response = await _client
        .from('user_profiles')
        .update(updates)
        .eq('id', userId)
        .select()
        .single();
    return response;
  }

  Stream<Map<String, dynamic>> watchProfile(String userId) {
    return _client
        .from('user_profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((events) => events.first);
  }
}
