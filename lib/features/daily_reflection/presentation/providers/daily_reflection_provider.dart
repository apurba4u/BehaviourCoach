import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:discipline_os/features/daily_reflection/domain/entities/daily_reflection_entity.dart';
import 'package:discipline_os/features/daily_reflection/domain/repositories/daily_reflection_repository.dart';
import 'package:discipline_os/features/daily_reflection/data/repositories/daily_reflection_repository_impl.dart';
import 'package:discipline_os/features/daily_reflection/domain/usecases/create_reflection.dart';
import 'package:discipline_os/features/daily_reflection/domain/usecases/get_reflections.dart';

final dailyReflectionRepositoryProvider = Provider<DailyReflectionRepository>(
  (ref) {
    return DailyReflectionRepositoryImpl();
  },
);

final createReflectionProvider = Provider<CreateReflection>((ref) {
  final repository = ref.watch(dailyReflectionRepositoryProvider);
  return CreateReflection(repository);
});

final getReflectionsProvider = Provider<GetReflections>((ref) {
  final repository = ref.watch(dailyReflectionRepositoryProvider);
  return GetReflections(repository);
});

enum DailyReflectionListState { initial, loading, loaded, error }

class DailyReflectionListDataState {
  final DailyReflectionListState state;
  final List<DailyReflectionEntity> reflections;
  final String? error;

  const DailyReflectionListDataState({
    this.state = DailyReflectionListState.initial,
    this.reflections = const [],
    this.error,
  });

  DailyReflectionListDataState copyWith({
    DailyReflectionListState? state,
    List<DailyReflectionEntity>? reflections,
    String? error,
  }) {
    return DailyReflectionListDataState(
      state: state ?? this.state,
      reflections: reflections ?? this.reflections,
      error: error ?? this.error,
    );
  }
}

class DailyReflectionListNotifier
    extends StateNotifier<DailyReflectionListDataState> {
  final GetReflections _getReflections;
  final CreateReflection _createReflection;

  DailyReflectionListNotifier({
    required GetReflections getReflections,
    required CreateReflection createReflection,
  })  : _getReflections = getReflections,
        _createReflection = createReflection,
        super(const DailyReflectionListDataState());

  Future<void> loadReflections(String userId) async {
    state = state.copyWith(state: DailyReflectionListState.loading);

    final result = await _getReflections(
      userId: userId,
    );

    result.fold(
      (failure) => state = state.copyWith(
        state: DailyReflectionListState.error,
        error: failure.message,
      ),
      (reflections) => state = state.copyWith(
        state: DailyReflectionListState.loaded,
        reflections: reflections,
      ),
    );
  }

  Future<void> saveReflection({
    required String userId,
    required ReflectionType reflectionType,
    String? mood,
    int? energyLevel,
    String? content,
  }) async {
    state = state.copyWith(state: DailyReflectionListState.loading);

    final result = await _createReflection(
      userId: userId,
      params: CreateReflectionParams(
        userId: userId,
        reflectionType: reflectionType,
        mood: mood,
        energyLevel: energyLevel,
        content: content,
      ),
    );

    result.fold(
      (failure) => state = state.copyWith(
        state: DailyReflectionListState.error,
        error: failure.message,
      ),
      (reflection) {
        final updated = [reflection, ...state.reflections];
        state = state.copyWith(
          state: DailyReflectionListState.loaded,
          reflections: updated,
        );
      },
    );
  }
}

final dailyReflectionListProvider = StateNotifierProvider<
    DailyReflectionListNotifier, DailyReflectionListDataState>((ref) {
  final getReflections = ref.watch(getReflectionsProvider);
  final createReflection = ref.watch(createReflectionProvider);
  return DailyReflectionListNotifier(
    getReflections: getReflections,
    createReflection: createReflection,
  );
});
