import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/redux/actions/main.dart';

enum SortType {
  recent,
  active,
  name,
  owed,
  payments,
  price,
  reset,
}

class InitJobs extends ActionType<List<JobModel>> {
  @override
  final String type = ReduxActions.initJobs;

  InitJobs({List<JobModel> payload}) : super(payload: payload);
}

class AddJob extends ActionType<JobModel> {
  @override
  final String type = ReduxActions.addJob;

  AddJob({JobModel payload}) : super(payload: payload);
}

class RemoveJob extends ActionType<JobModel> {
  @override
  final String type = ReduxActions.removeJob;

  RemoveJob({JobModel payload}) : super(payload: payload);
}

class ToggleCompleteJob extends ActionType<JobModel> {
  @override
  final String type = ReduxActions.removeJob;

  ToggleCompleteJob({JobModel payload}) : super(payload: payload);
}

class SortJobs extends ActionType<SortType> {
  @override
  final String type = ReduxActions.sortJobs;

  SortJobs({SortType payload}) : super(payload: payload);
}

class OnDataEvent extends ActionType<List<JobModel>> {
  @override
  final String type = ReduxActions.onDataEventJob;

  OnDataEvent({List<JobModel> payload}) : super(payload: payload);
}
