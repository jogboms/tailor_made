import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class InitJobsAction extends Action {
  const InitJobsAction(this.userId);

  final String? userId;
}

class ToggleCompleteJob extends Action {
  const ToggleCompleteJob(this.payload);

  final JobModel payload;
}

class SortJobs extends Action {
  const SortJobs(this.payload);

  final JobsSortType payload;
}

class SearchSuccessJobAction extends Action {
  const SearchSuccessJobAction(this.payload);

  final List<JobModel> payload;
}

class CancelSearchJobAction extends Action {
  const CancelSearchJobAction();
}

class StartSearchJobAction extends Action {
  const StartSearchJobAction();
}

class SearchJobAction extends Action {
  const SearchJobAction(this.payload);

  final String payload;
}
