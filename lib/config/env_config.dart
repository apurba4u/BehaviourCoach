import 'package:flutter_dotenv/flutter_dotenv.dart';

/// DisciplineOS Environment Configuration
/// Loads environment variables from .env files
class EnvConfig {
  EnvConfig._();

  static String get appEnv => dotenv.env['APP_ENV'] ?? 'development';
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';

  static bool get isDevelopment => appEnv == 'development';
  static bool get isProduction => appEnv == 'production';

  static Future<void> init() async {
    await dotenv.load();
  }
}
