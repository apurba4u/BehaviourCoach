import 'package:equatable/equatable.dart';

/// Behavioral Log Entity
class BehavioralLogEntity extends Equatable {
  final String id;
  final String userId;
  final String logType;
  final int? score;
  final int? durationMinutes;
  final Map<String, dynamic> metadata;
  final DateTime recordedAt;
  final DateTime createdAt;

  const BehavioralLogEntity({
    required this.id,
    required this.userId,
    required this.logType,
    this.score,
    this.durationMinutes,
    this.metadata = const {},
    required this.recordedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        logType,
        score,
        durationMinutes,
        metadata,
        recordedAt,
        createdAt,
      ];
}
