import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/job.dart';

enum SortType {
  recent,
  active,
  name,
  owed,
  payments,
  price,
  reset,
}

class ToggleCompleteJob extends Action {
  const ToggleCompleteJob({
    @required this.payload,
  });

  final JobModel payload;
}

class SortJobs extends Action {
  const SortJobs({
    @required this.payload,
  });

  final SortType payload;
}

class SearchSuccessJobEvent extends Action {
  const SearchSuccessJobEvent({
    @required this.payload,
  });

  final List<JobModel> payload;
}

class CancelSearchJobEvent extends Action {
  const CancelSearchJobEvent();
}

class StartSearchJobEvent extends Action {
  const StartSearchJobEvent();
}

class SearchJobEvent extends Action {
  const SearchJobEvent({
    @required this.payload,
  });

  final String payload;
}

class OnDataJobEvent extends Action {
  const OnDataJobEvent({
    @required this.payload,
  });

  final List<JobModel> payload;
}
