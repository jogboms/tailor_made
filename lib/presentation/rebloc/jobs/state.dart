part of 'bloc.dart';

@freezed
class JobsState with _$JobsState {
  const factory JobsState({
    required List<JobEntity>? jobs,
    required bool hasSortFn,
    required JobsSortType sortFn,
    required List<JobEntity>? searchResults,
    required bool isSearching,
    required StateStatus status,
    required String? error,
  }) = _JobsState;
}
