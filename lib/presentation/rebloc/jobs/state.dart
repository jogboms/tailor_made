part of 'bloc.dart';

@freezed
class JobsState with _$JobsState {
  const factory JobsState({
    required List<JobModel>? jobs,
    required bool hasSortFn,
    required JobsSortType sortFn,
    required List<JobModel>? searchResults,
    required bool isSearching,
    required StateStatus status,
    required String? error,
  }) = _JobsState;
}
