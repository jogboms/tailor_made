import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/jobs.dart';
import 'package:tailor_made/redux/states/main.dart';

JobsState reducer(ReduxState state, ActionType action) {
  final JobsState jobs = state.jobs;

  switch (action.type) {
    case ReduxActions.initJobs:
    case ReduxActions.onDataEventJob:
      return jobs.copyWith(jobs: action.payload);

    case ReduxActions.addJob:
      List<JobModel> _jobs = new List.from(jobs.jobs)..add(action.payload);
      return jobs.copyWith(jobs: _jobs);

    case ReduxActions.removeJob:
      List<JobModel> _jobs = jobs.jobs
          .where(
            (job) => job.documentID != action.payload.documentID,
          )
          .toList();
      return jobs.copyWith(jobs: _jobs);

    default:
      return jobs;
  }
}
