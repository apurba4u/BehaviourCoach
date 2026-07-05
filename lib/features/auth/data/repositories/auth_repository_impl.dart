import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:discipline_os/core/errors/failure.dart';
import 'package:discipline_os/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:discipline_os/features/auth/domain/entities/user_entity.dart';
import 'package:discipline_os/features/auth/domain/repositories/auth_repository.dart';

/// DisciplineOS Auth Repository Implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  UserEntity _userToEntity(User user) {
    return UserEntity(
      id: user.id,
      email: user.email ?? '',
      displayName: user.userMetadata?['display_name'] as String?,
      avatarUrl: user.userMetadata?['avatar_url'] as String?,
      identityLevel: user.userMetadata?['identity_level'] as String? ?? 'novice',
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _remoteDataSource.signInWithEmail(
        email: email,
        password: password,
      );
      return Right(_userToEntity(user));
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final user = await _remoteDataSource.signUpWithEmail(
        email: email,
        password: password,
        displayName: displayName,
      );
      return Right(_userToEntity(user));
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await _remoteDataSource.signInWithGoogle();
      return Right(_userToEntity(user));
    } on AuthException catch (e) {
      return Left(AuthenticationFailure(message: e.message));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _remoteDataSource.getUser();
      if (user == null) {
        return const Right(null);
      }
      return Right(_userToEntity(user));
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((authState) {
      final session = authState.session;
      if (session == null) return null;
      return _userToEntity(session.user);
    });
  }

  @override
  Future<Either<Failure, Unit>> resetPassword(String email) async {
    try {
      await _remoteDataSource.resetPassword(email);
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProfile({
    String? displayName,
    String? avatarUrl,
  }) async {
    try {
      await _remoteDataSource.updateProfile(
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
      return const Right(unit);
    } catch (e) {
      return Left(UnexpectedFailure(message: e.toString()));
    }
  }
}
