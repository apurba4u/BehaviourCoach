import 'package:equatable/equatable.dart';

/// Focus Session Entity
class FocusSessionEntity extends Equatable {
  final String id;
  final String userId;
  final String? title;
  final String? protocol;
  final int durationMinutes;
  final int? actualMinutes;
  final String status;
  final int? score;
  final String? ambientSound;
  final int distractionsCount;
  final DateTime startedAt;
  final DateTime? endedAt;
  final DateTime createdAt;

  const FocusSessionEntity({
    required this.id,
    required this.userId,
    this.title,
    this.protocol,
    required this.durationMinutes,
    this.actualMinutes,
    this.status = 'active',
    this.score,
    this.ambientSound,
    this.distractionsCount = 0,
    required this.startedAt,
    this.endedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        protocol,
        durationMinutes,
        actualMinutes,
        status,
        score,
        ambientSound,
        distractionsCount,
        startedAt,
        endedAt,
        createdAt,
      ];
}
