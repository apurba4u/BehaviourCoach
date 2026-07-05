import 'package:equatable/equatable.dart';

/// DisciplineOS User Entity
class UserEntity extends Equatable {
  final String id;
  final String email;
  final DateTime createdAt;
  final String? displayName;
  final String? avatarUrl;
  final String identityLevel;

  const UserEntity({
    required this.id,
    required this.email,
    required this.createdAt,
    this.displayName,
    this.avatarUrl,
    this.identityLevel = 'novice',
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        avatarUrl,
        identityLevel,
        createdAt,
      ];
}
