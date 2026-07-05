import 'package:equatable/equatable.dart';

/// Focus Session Entity
class FocusSession extends Equatable {
  final String id;
  final String userId;
  final String? title;
  final String? protocol;
  final int durationMinutes;
  final int? actualMinutes;
  final FocusSessionStatus status;
  final int? score;
  final String? ambientSound;
  final int distractionsCount;
  final DateTime startedAt;
  final DateTime? endedAt;
  final DateTime? pausedAt;
  final DateTime createdAt;

  const FocusSession({
    required this.id,
    required this.userId,
    this.title,
    this.protocol,
    required this.durationMinutes,
    this.actualMinutes,
    this.status = FocusSessionStatus.active,
    this.score,
    this.ambientSound,
    this.distractionsCount = 0,
    required this.startedAt,
    this.endedAt,
    this.pausedAt,
    required this.createdAt,
  });

  /// Get remaining minutes
  int get remainingMinutes {
    if (status != FocusSessionStatus.active) return 0;
    final elapsed = DateTime.now().difference(startedAt).inMinutes;
    return (durationMinutes - elapsed).clamp(0, durationMinutes);
  }

  /// Get remaining seconds
  int get remainingSeconds {
    if (status != FocusSessionStatus.active) return 0;
    final elapsed = DateTime.now().difference(startedAt).inSeconds;
    final totalSeconds = durationMinutes * 60;
    return (totalSeconds - elapsed).clamp(0, totalSeconds);
  }

  /// Get progress percentage (0.0 to 1.0)
  double get progress {
    final elapsed = DateTime.now().difference(startedAt).inSeconds;
    final totalSeconds = durationMinutes * 60;
    return (elapsed / totalSeconds).clamp(0.0, 1.0);
  }

  /// Get formatted remaining time
  String get formattedRemaining {
    final minutes = remainingMinutes;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Create a copy with updates
  FocusSession copyWith({
    String? title,
    String? protocol,
    int? durationMinutes,
    int? actualMinutes,
    FocusSessionStatus? status,
    int? score,
    String? ambientSound,
    int? distractionsCount,
    DateTime? endedAt,
    DateTime? pausedAt,
  }) {
    return FocusSession(
      id: id,
      userId: userId,
      title: title ?? this.title,
      protocol: protocol ?? this.protocol,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      status: status ?? this.status,
      score: score ?? this.score,
      ambientSound: ambientSound ?? this.ambientSound,
      distractionsCount: distractionsCount ?? this.distractionsCount,
      startedAt: startedAt,
      endedAt: endedAt ?? this.endedAt,
      pausedAt: pausedAt ?? this.pausedAt,
      createdAt: createdAt,
    );
  }

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
        pausedAt,
        createdAt,
      ];
}

/// Focus Session Status
enum FocusSessionStatus {
  active,
  paused,
  completed,
  cancelled,
}

/// Focus Session Params for starting a session
class FocusSessionParams extends Equatable {
  final String? title;
  final String? protocol;
  final int durationMinutes;
  final String? ambientSound;

  const FocusSessionParams({
    this.title,
    this.protocol,
    required this.durationMinutes,
    this.ambientSound,
  });

  @override
  List<Object?> get props => [title, protocol, durationMinutes, ambientSound];
}

/// Ambient Sound Options
enum AmbientSound {
  oceanDeep('Ocean Deep', 'waves'),
  blackForest('Black Forest', 'forest'),
  whiteNoise('White Noise', 'grain'),
  midnightStorm('Midnight Storm', 'thunderstorm');

  final String displayName;
  final String icon;

  const AmbientSound(this.displayName, this.icon);
}
