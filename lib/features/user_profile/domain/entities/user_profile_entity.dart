import 'package:equatable/equatable.dart';

/// User Profile Entity
class UserProfileEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? avatarUrl;
  final String identityLevel;
  final int identityScore;
  final String timezone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserProfileEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.avatarUrl,
    this.identityLevel = 'novice',
    this.identityScore = 0,
    this.timezone = 'UTC',
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        avatarUrl,
        identityLevel,
        identityScore,
        timezone,
        createdAt,
        updatedAt,
      ];
}
