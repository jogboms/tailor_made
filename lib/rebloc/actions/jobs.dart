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

class SearchSuccessJobAction extends Action {
  const SearchSuccessJobAction({
    @required this.payload,
  });

  final List<JobModel> payload;
}

class CancelSearchJobAction extends Action {
  const CancelSearchJobAction();
}

class StartSearchJobAction extends Action {
  const StartSearchJobAction();
}

class SearchJobAction extends Action {
  const SearchJobAction({
    @required this.payload,
  });

  final String payload;
}

class OnDataJobAction extends Action {
  const OnDataJobAction({
    @required this.payload,
  });

  final List<JobModel> payload;
}
