import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/redux/actions/main.dart';

class InitJobs extends ActionType {
  @override
  final String type = ReduxActions.initJobs;
  final List<JobModel> payload;

  InitJobs({this.payload});
}

class AddJob extends ActionType {
  @override
  final String type = ReduxActions.addJob;
  final JobModel payload;

  AddJob({this.payload});
}

class RemoveJob extends ActionType {
  @override
  final String type = ReduxActions.removeJob;
  final JobModel payload;

  RemoveJob({this.payload});
}

class ToggleCompleteJob extends ActionType {
  @override
  final String type = ReduxActions.removeJob;
  final JobModel payload;

  ToggleCompleteJob({this.payload});
}

class OnDataEvent extends ActionType {
  @override
  final String type = ReduxActions.onDataEventJob;
  final List<JobModel> payload;

  OnDataEvent({this.payload});
}
