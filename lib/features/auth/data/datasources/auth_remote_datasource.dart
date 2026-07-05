import 'package:discipline_os/config/supabase_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// DisciplineOS Auth Remote Data Source
class AuthRemoteDataSource {
  final SupabaseClient _client;

  AuthRemoteDataSource({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  GoTrueClient get _auth => _client.auth;

  User? get currentUser => _auth.currentUser;

  Session? get currentSession => _auth.currentSession;

  Stream<AuthState> get authStateChanges => _auth.onAuthStateChange;

  User? getUser() {
    return _auth.currentUser;
  }

  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _auth.signInWithPassword(
      email: email,
      password: password,
    );
    if (response.user == null) {
      throw Exception('Sign in failed');
    }
    return response.user!;
  }

  Future<User> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    final response = await _auth.signUp(
      email: email,
      password: password,
      data: {'display_name': displayName},
    );
    if (response.user == null) {
      throw Exception('Sign up failed');
    }
    return response.user!;
  }

  Future<User> signInWithGoogle() async {
    await _auth.signInWithOAuth(
      OAuthProvider.google,
    );
    if (currentUser == null) {
      throw Exception('Google sign in failed');
    }
    return currentUser!;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.resetPasswordForEmail(email);
  }

  Future<User> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    final response = await _auth.updateUser(
      UserAttributes(
        data: {
          if (displayName != null) 'display_name': displayName,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
        },
      ),
    );
    if (response.user == null) {
      throw Exception('Update profile failed');
    }
    return response.user!;
  }
}
