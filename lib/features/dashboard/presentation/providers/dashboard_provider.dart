import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/features/dashboard/domain/entities/dashboard_entity.dart';
import 'package:discipline_os/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:discipline_os/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:discipline_os/features/dashboard/domain/usecases/get_dashboard_data.dart';
import 'package:discipline_os/features/dashboard/domain/usecases/refresh_dashboard_data.dart';

/// Dashboard Repository Provider
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepositoryImpl();
});

/// Get Dashboard Data Provider
final getDashboardDataProvider = Provider<GetDashboardData>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return GetDashboardData(repository);
});

/// Refresh Dashboard Data Provider
final refreshDashboardDataProvider = Provider<RefreshDashboardData>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return RefreshDashboardData(repository);
});

/// Dashboard State
enum DashboardState { initial, loading, loaded, error }

/// Dashboard Data State
class DashboardDataState {
  final DashboardState state;
  final DashboardData? data;
  final String? error;

  const DashboardDataState({
    this.state = DashboardState.initial,
    this.data,
    this.error,
  });

  DashboardDataState copyWith({
    DashboardState? state,
    DashboardData? data,
    String? error,
  }) {
    return DashboardDataState(
      state: state ?? this.state,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}

/// Dashboard Notifier
class DashboardNotifier extends StateNotifier<DashboardDataState> {
  final GetDashboardData _getDashboardData;
  final RefreshDashboardData _refreshDashboardData;

  DashboardNotifier({
    required GetDashboardData getDashboardData,
    required RefreshDashboardData refreshDashboardData,
  })  : _getDashboardData = getDashboardData,
        _refreshDashboardData = refreshDashboardData,
        super(const DashboardDataState());

  /// Load dashboard data
  Future<void> loadDashboard(String userId) async {
    state = state.copyWith(state: DashboardState.loading);

    final result = await _getDashboardData(userId);

    result.fold(
      (failure) => state = state.copyWith(
        state: DashboardState.error,
        error: failure.message,
      ),
      (data) => state = state.copyWith(
        state: DashboardState.loaded,
        data: data,
      ),
    );
  }

  /// Refresh dashboard data
  Future<void> refreshDashboard(String userId) async {
    state = state.copyWith(state: DashboardState.loading);

    final result = await _refreshDashboardData(userId);

    result.fold(
      (failure) => state = state.copyWith(
        state: DashboardState.error,
        error: failure.message,
      ),
      (data) => state = state.copyWith(
        state: DashboardState.loaded,
        data: data,
      ),
    );
  }

  /// Reset state
  void reset() {
    state = const DashboardDataState();
  }
}

/// Dashboard Notifier Provider
final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardDataState>((ref) {
  final getDashboardData = ref.watch(getDashboardDataProvider);
  final refreshDashboardData = ref.watch(refreshDashboardDataProvider);

  return DashboardNotifier(
    getDashboardData: getDashboardData,
    refreshDashboardData: refreshDashboardData,
  );
});
