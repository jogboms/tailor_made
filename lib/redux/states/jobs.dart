import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/redux/actions/jobs.dart';

enum JobsStatus {
  loading,
  success,
  failure,
}

@immutable
class JobsState {
  final List<JobModel> jobs;
  final JobsStatus status;
  final String message;
  final bool hasSortFn;
  final SortType sortFn;

  const JobsState({
    @required this.jobs,
    @required this.status,
    @required this.message,
    @required this.hasSortFn,
    @required this.sortFn,
  });

  const JobsState.initialState()
      : jobs = null,
        status = JobsStatus.loading,
        hasSortFn = false,
        sortFn = SortType.reset,
        message = '';

  JobsState copyWith({
    List<JobModel> jobs,
    JobsStatus status,
    String message,
    bool hasSortFn,
    SortType sortFn,
  }) {
    return new JobsState(
      jobs: jobs ?? this.jobs,
      status: status ?? this.status,
      message: message ?? this.message,
      hasSortFn: hasSortFn ?? this.hasSortFn,
      sortFn: sortFn ?? this.sortFn,
    );
  }
}
