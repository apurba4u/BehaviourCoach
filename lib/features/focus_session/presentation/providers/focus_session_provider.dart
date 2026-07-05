import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/features/focus_session/domain/entities/focus_session_entity.dart';
import 'package:discipline_os/features/focus_session/domain/repositories/focus_session_repository.dart';
import 'package:discipline_os/features/focus_session/data/repositories/focus_session_repository_impl.dart';
import 'package:discipline_os/features/focus_session/domain/usecases/start_focus_session.dart';
import 'package:discipline_os/features/focus_session/domain/usecases/pause_focus_session.dart';
import 'package:discipline_os/features/focus_session/domain/usecases/resume_focus_session.dart';
import 'package:discipline_os/features/focus_session/domain/usecases/end_focus_session.dart';
import 'package:discipline_os/features/focus_session/domain/usecases/get_active_session.dart';
import 'package:discipline_os/features/dashboard/presentation/providers/dashboard_provider.dart';

/// Focus Session Repository Provider
final focusSessionRepositoryProvider = Provider<FocusSessionRepository>((ref) {
  return FocusSessionRepositoryImpl();
});

/// Start Focus Session Provider
final startFocusSessionProvider = Provider<StartFocusSession>((ref) {
  final repository = ref.watch(focusSessionRepositoryProvider);
  return StartFocusSession(repository);
});

/// Pause Focus Session Provider
final pauseFocusSessionProvider = Provider<PauseFocusSession>((ref) {
  final repository = ref.watch(focusSessionRepositoryProvider);
  return PauseFocusSession(repository);
});

/// Resume Focus Session Provider
final resumeFocusSessionProvider = Provider<ResumeFocusSession>((ref) {
  final repository = ref.watch(focusSessionRepositoryProvider);
  return ResumeFocusSession(repository);
});

/// End Focus Session Provider
final endFocusSessionProvider = Provider<EndFocusSession>((ref) {
  final repository = ref.watch(focusSessionRepositoryProvider);
  return EndFocusSession(repository);
});

/// Get Active Session Provider
final getActiveSessionProvider = Provider<GetActiveSession>((ref) {
  final repository = ref.watch(focusSessionRepositoryProvider);
  return GetActiveSession(repository);
});

/// Focus Session State
enum FocusSessionState {
  idle,
  starting,
  active,
  paused,
  completing,
  completed,
  error,
}

/// Focus Session Data State
class FocusSessionDataState {
  final FocusSessionState state;
  final FocusSession? session;
  final String? error;
  final int remainingSeconds;
  final Timer? timer;

  const FocusSessionDataState({
    this.state = FocusSessionState.idle,
    this.session,
    this.error,
    this.remainingSeconds = 0,
    this.timer,
  });

  FocusSessionDataState copyWith({
    FocusSessionState? state,
    FocusSession? session,
    String? error,
    int? remainingSeconds,
    Timer? timer,
    bool clearTimer = false,
  }) {
    return FocusSessionDataState(
      state: state ?? this.state,
      session: session ?? this.session,
      error: error ?? this.error,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      timer: clearTimer ? null : (timer ?? this.timer),
    );
  }
}

/// Focus Session Notifier
class FocusSessionNotifier extends StateNotifier<FocusSessionDataState> {
  final StartFocusSession _startSession;
  final PauseFocusSession _pauseSession;
  final ResumeFocusSession _resumeSession;
  final EndFocusSession _endSession;
  final GetActiveSession _getActiveSession;
  final Ref _ref;

  FocusSessionNotifier({
    required StartFocusSession startSession,
    required PauseFocusSession pauseSession,
    required ResumeFocusSession resumeSession,
    required EndFocusSession endSession,
    required GetActiveSession getActiveSession,
    required Ref ref,
  })  : _startSession = startSession,
        _pauseSession = pauseSession,
        _resumeSession = resumeSession,
        _endSession = endSession,
        _getActiveSession = getActiveSession,
        _ref = ref,
        super(const FocusSessionDataState());

  /// Start a new focus session
  Future<void> startSession({
    required String userId,
    required FocusSessionParams params,
  }) async {
    state = state.copyWith(state: FocusSessionState.starting);

    final result = await _startSession(userId: userId, params: params);

    result.fold(
      (failure) => state = state.copyWith(
        state: FocusSessionState.error,
        error: failure.message,
      ),
      (session) {
        state = state.copyWith(
          state: FocusSessionState.active,
          session: session,
          remainingSeconds: session.durationMinutes * 60,
        );
        _startTimer();
      },
    );
  }

  /// Pause the current session
  Future<void> pauseSession() async {
    if (state.session == null) return;

    state = state.copyWith(state: FocusSessionState.paused);
    _stopTimer();

    final result = await _pauseSession(state.session!.id);

    result.fold(
      (failure) => state = state.copyWith(
        state: FocusSessionState.error,
        error: failure.message,
      ),
      (session) {
        state = state.copyWith(
          state: FocusSessionState.completed,
          session: session,
        );
        // Invalidate dashboard provider to refresh data
        _ref.invalidate(dashboardNotifierProvider);
      },
    );
  }

  /// Resume the current session
  Future<void> resumeSession() async {
    if (state.session == null) return;

    final result = await _resumeSession(state.session!.id);

    result.fold(
      (failure) => state = state.copyWith(
        state: FocusSessionState.error,
        error: failure.message,
      ),
      (session) {
        state = state.copyWith(
          state: FocusSessionState.active,
          session: session,
        );
        _startTimer();
      },
    );
  }

  /// End the current session
  Future<void> endSession({
    int? score,
    int? distractionsCount,
  }) async {
    if (state.session == null) return;

    state = state.copyWith(state: FocusSessionState.completing);
    _stopTimer();

    final result = await _endSession(
      sessionId: state.session!.id,
      score: score,
      distractionsCount: distractionsCount,
    );

    result.fold(
      (failure) => state = state.copyWith(
        state: FocusSessionState.error,
        error: failure.message,
      ),
      (session) {
        state = state.copyWith(
          state: FocusSessionState.completed,
          session: session,
        );
      },
    );
  }

  /// Cancel the current session
  Future<void> cancelSession() async {
    if (state.session == null) return;

    _stopTimer();

    final result = await _endSession(
      sessionId: state.session!.id,
    );

    result.fold(
      (failure) => state = state.copyWith(
        state: FocusSessionState.error,
        error: failure.message,
      ),
      (session) {
        state = state.copyWith(
          state: FocusSessionState.completed,
          session: session,
        );
      },
    );
  }

  /// Load active session
  Future<void> loadActiveSession(String userId) async {
    final result = await _getActiveSession(userId);

    result.fold(
      (failure) {
        // No active session, that's fine
      },
      (session) {
        if (session != null) {
          state = state.copyWith(
            state: FocusSessionState.active,
            session: session,
            remainingSeconds: session.remainingSeconds,
          );
          _startTimer();
        }
      },
    );
  }

  /// Start the countdown timer
  void _startTimer() {
    _stopTimer();

    state = state.copyWith(
      timer: Timer.periodic(const Duration(seconds: 1), (_) {
        if (state.remainingSeconds > 0) {
          state = state.copyWith(
            remainingSeconds: state.remainingSeconds - 1,
          );

          // Auto-complete when timer reaches zero
          if (state.remainingSeconds <= 0) {
            endSession(score: _calculateScore());
          }
        }
      }),
    );
  }

  /// Stop the countdown timer
  void _stopTimer() {
    state.timer?.cancel();
    state = state.copyWith(clearTimer: true);
  }

  /// Calculate score based on completion
  int _calculateScore() {
    if (state.session == null) return 0;

    final completed = state.remainingSeconds <= 0;
    if (!completed) return 0;

    // Base score for completion
    var score = 80;

    // Bonus for no distractions
    if (state.session!.distractionsCount == 0) {
      score += 10;
    }

    // Bonus for longer sessions
    if (state.session!.durationMinutes >= 45) {
      score += 10;
    }

    return score.clamp(0, 100);
  }

  /// Reset state
  void reset() {
    _stopTimer();
    state = const FocusSessionDataState();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }
}

/// Focus Session Notifier Provider
final focusSessionNotifierProvider =
    StateNotifierProvider<FocusSessionNotifier, FocusSessionDataState>((ref) {
  final startSession = ref.watch(startFocusSessionProvider);
  final pauseSession = ref.watch(pauseFocusSessionProvider);
  final resumeSession = ref.watch(resumeFocusSessionProvider);
  final endSession = ref.watch(endFocusSessionProvider);
  final getActiveSession = ref.watch(getActiveSessionProvider);

  return FocusSessionNotifier(
    startSession: startSession,
    pauseSession: pauseSession,
    resumeSession: resumeSession,
    endSession: endSession,
    getActiveSession: getActiveSession,
    ref: ref,
  );
});

/// Selected Ambient Sound Provider
final selectedAmbientSoundProvider = StateProvider<AmbientSound?>((ref) {
  return null;
});
