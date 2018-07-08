import 'package:flutter/foundation.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';

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

  JobsState({this.jobs, this.status, this.message});

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

JobsState initialState = JobsState(
  jobs: null,
  status: JobsStatus.loading,
  message: "",
);
