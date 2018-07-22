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

class ToggleCompleteJob extends ActionType<JobModel> {
  ToggleCompleteJob({
    JobModel payload,
  }) : super(payload: payload);
}

class SortJobs extends ActionType<SortType> {
  SortJobs({
    SortType payload,
  }) : super(payload: payload);
}

class SearchSuccessJobEvent extends ActionType<List<JobModel>> {
  SearchSuccessJobEvent({
    List<JobModel> payload,
  }) : super(payload: payload);
}

class CancelSearchJobEvent extends ActionType<void> {}

class StartSearchJobEvent extends ActionType<void> {}

class SearchJobEvent extends ActionType<String> {
  SearchJobEvent({
    String payload,
  }) : super(payload: payload);
}

class OnDataJobEvent extends ActionType<List<JobModel>> {
  OnDataJobEvent({
    List<JobModel> payload,
  }) : super(payload: payload);
}
