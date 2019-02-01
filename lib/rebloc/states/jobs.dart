import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/rebloc/actions/jobs.dart';

enum JobsStatus {
  loading,
  success,
  failure,
}

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
        status = JobsStatus.loading,
        hasSortFn = true,
        sortFn = SortType.active,
        searchResults = null,
        isSearching = false,
        message = '',
        error = null;

  final List<JobModel> jobs;
  final JobsStatus status;
  final String message;
  final bool hasSortFn;
  final SortType sortFn;
  final List<JobModel> searchResults;
  final bool isSearching;
  final dynamic error;

  JobsState copyWith({
    List<JobModel> jobs,
    JobsStatus status,
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
  String toString() {
    return '\nJobs: $jobs, \nHasSortFn: $hasSortFn, \nSortFn: $sortFn, \nSearchResults: $searchResults, \nIsSearching: $isSearching';
  }
}
