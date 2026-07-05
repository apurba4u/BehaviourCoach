import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:discipline_os/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:discipline_os/features/auth/domain/entities/user_entity.dart';
import 'package:discipline_os/features/auth/domain/repositories/auth_repository.dart';
import 'package:discipline_os/features/auth/domain/usecases/get_current_user.dart';
import 'package:discipline_os/features/auth/domain/usecases/sign_in_with_email.dart';
import 'package:discipline_os/features/auth/domain/usecases/sign_out.dart';
import 'package:discipline_os/features/auth/domain/usecases/sign_up_with_email.dart';

/// Auth Remote Data Source Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource();
});

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Sign In With Email Provider
final signInWithEmailProvider = Provider<SignInWithEmail>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignInWithEmail(repository);
});

/// Sign Up With Email Provider
final signUpWithEmailProvider = Provider<SignUpWithEmail>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpWithEmail(repository);
});

/// Sign Out Provider
final signOutProvider = Provider<SignOut>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignOut(repository);
});

/// Get Current User Provider
final getCurrentUserProvider = Provider<GetCurrentUser>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return GetCurrentUser(repository);
});

/// Auth State Provider
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges;
});

/// Current User Provider
final currentUserProvider = FutureProvider<UserEntity?>((ref) async {
  final getCurrentUser = ref.watch(getCurrentUserProvider);
  final result = await getCurrentUser();
  return result.fold(
    (failure) => null,
    (user) => user,
  );
});

/// Auth State Enum
enum AuthState { initial, loading, authenticated, unauthenticated, error }

/// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignOut _signOut;

  AuthNotifier({
    required SignInWithEmail signInWithEmail,
    required SignUpWithEmail signUpWithEmail,
    required SignOut signOut,
  })  : _signInWithEmail = signInWithEmail,
        _signUpWithEmail = signUpWithEmail,
        _signOut = signOut,
        super(AuthState.initial);

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = AuthState.loading;
    final result = await _signInWithEmail(
      SignInWithEmailParams(email: email, password: password),
    );
    result.fold(
      (failure) => state = AuthState.error,
      (user) => state = AuthState.authenticated,
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = AuthState.loading;
    final result = await _signUpWithEmail(
      SignUpWithEmailParams(
        email: email,
        password: password,
        displayName: displayName,
      ),
    );
    result.fold(
      (failure) => state = AuthState.error,
      (user) => state = AuthState.authenticated,
    );
  }

  Future<void> signOut() async {
    state = AuthState.loading;
    final result = await _signOut();
    result.fold(
      (failure) => state = AuthState.error,
      (_) => state = AuthState.unauthenticated,
    );
  }
}

/// Auth Notifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final signInWithEmail = ref.watch(signInWithEmailProvider);
  final signUpWithEmail = ref.watch(signUpWithEmailProvider);
  final signOut = ref.watch(signOutProvider);
  return AuthNotifier(
    signInWithEmail: signInWithEmail,
    signUpWithEmail: signUpWithEmail,
    signOut: signOut,
  );
});
