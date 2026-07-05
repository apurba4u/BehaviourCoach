import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/config/supabase_config.dart';

/// App Setting Remote Data Source
class AppSettingRemoteDataSource {
  final SupabaseClient _client;

  AppSettingRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  Future<Map<String, dynamic>> getSetting({
    required String userId,
    required String settingKey,
  }) async {
    final response = await _client
        .from('app_settings')
        .select()
        .eq('user_id', userId)
        .eq('setting_key', settingKey)
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getAllSettings(String userId) async {
    final response = await _client
        .from('app_settings')
        .select()
        .eq('user_id', userId);
    return response;
  }

  Future<Map<String, dynamic>> upsertSetting({
    required String userId,
    required String settingKey,
    required dynamic settingValue,
  }) async {
    final response = await _client
        .from('app_settings')
        .upsert({
          'user_id': userId,
          'setting_key': settingKey,
          'setting_value': settingValue,
        })
        .select()
        .single();
    return response;
  }

  Future<void> deleteSetting({
    required String userId,
    required String settingKey,
  }) async {
    await _client
        .from('app_settings')
        .delete()
        .eq('user_id', userId)
        .eq('setting_key', settingKey);
  }
}
