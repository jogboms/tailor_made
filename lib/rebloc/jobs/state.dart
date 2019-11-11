import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/jobs/actions.dart';

@immutable
class JobsState {
  const JobsState({
    @required this.jobs,
    @required this.status,
    @required this.message,
    @required this.hasSortFn,
    @required this.sortFn,
    @required this.searchResults,
    @required this.isSearching,
    this.error,
  });

  const JobsState.initialState()
      : jobs = null,
        status = StateStatus.loading,
        hasSortFn = true,
        sortFn = SortType.active,
        searchResults = null,
        isSearching = false,
        message = '',
        error = null;

  final List<JobModel> jobs;
  final StateStatus status;
  final String message;
  final bool hasSortFn;
  final SortType sortFn;
  final List<JobModel> searchResults;
  final bool isSearching;
  final dynamic error;

  JobsState copyWith({
    List<JobModel> jobs,
    StateStatus status,
    String message,
    bool hasSortFn,
    SortType sortFn,
    List<JobModel> searchResults,
    bool isSearching,
    dynamic error,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      status: status ?? this.status,
      message: message ?? this.message,
      hasSortFn: hasSortFn ?? this.hasSortFn,
      sortFn: sortFn ?? this.sortFn,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => """
Jobs: $jobs,
HasSortFn: $hasSortFn,
SortFn: $sortFn,
SearchResults: $searchResults,
IsSearching: $isSearching
    """;
}
