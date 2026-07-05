import 'package:equatable/equatable.dart';

/// DisciplineOS User Entity
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String identityLevel;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.identityLevel = 'novice',
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, email, displayName, avatarUrl, identityLevel, createdAt];
}
