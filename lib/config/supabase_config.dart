import 'package:discipline_os/config/env_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// DisciplineOS Supabase Configuration
class SupabaseConfig {
  SupabaseConfig._();

  static SupabaseClient? _client;

  static SupabaseClient get client {
    if (_client == null) {
      throw StateError(
        'Supabase not initialized. Call SupabaseConfig.init() first.',
      );
    }
    return _client!;
  }

  static GoTrueClient get auth => client.auth;

  static Future<void> init() async {
    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      publishableKey: EnvConfig.supabaseAnonKey,
    );
    _client = Supabase.instance.client;
  }

  static Future<void> dispose() async {
    await _client?.dispose();
    _client = null;
  }
}
