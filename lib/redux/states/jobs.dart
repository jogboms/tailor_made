import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/job.dart';

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

  const JobsState({this.jobs, this.status, this.message});

  const JobsState.initialState()
      : jobs = null,
        status = JobsStatus.loading,
        message = '';

  JobsState copyWith({
    List<JobModel> jobs,
    JobsStatus status,
    String message,
  }) {
    return new JobsState(
      jobs: jobs ?? this.jobs,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
