import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/redux/actions/jobs.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/jobs.dart';
import 'package:tailor_made/redux/states/main.dart';

List<JobModel> _sort(List<JobModel> _jobs, SortType sortType) {
  switch (sortType) {
    case SortType.active:
      _jobs.sort(
          (a, b) => (a.isComplete == b.isComplete) ? 0 : a.isComplete ? 1 : -1);
      break;
    case SortType.name:
      _jobs.sort((a, b) => a.name.compareTo(b.name));
      break;
    case SortType.payments:
      final _folder =
          (double value, PaymentModel element) => value + element.price;
      _jobs.sort(
        (a, b) => b.payments.fold<double>(0.0, _folder).compareTo(
              a.payments.fold<double>(0.0, _folder),
            ),
      );
      break;
    case SortType.owed:
      _jobs.sort((a, b) => b.pendingPayment.compareTo(a.pendingPayment));
      break;
    case SortType.price:
      _jobs.sort((a, b) => b.price.compareTo(a.price));
      break;
    case SortType.recent:
      _jobs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      break;
    case SortType.reset:
    default:
      _jobs.sort((a, b) => a.id.compareTo(b.id));
      break;
  }
  return _jobs;
}

JobsState reducer(ReduxState state, ActionType action) {
  final JobsState jobs = state.jobs;

  switch (action.type) {
    case ReduxActions.initJobs:
    case ReduxActions.onDataEventJob:
      return jobs.copyWith(
        jobs: _sort(action.payload, jobs.sortFn),
        status: JobsStatus.success,
      );

    case ReduxActions.onStartSearchJobEvent:
      return jobs.copyWith(
        status: JobsStatus.loading,
        isSearching: true,
      );

    case ReduxActions.onCancelSearchJobEvent:
      return jobs.copyWith(
        status: JobsStatus.success,
        isSearching: false,
        searchResults: [],
      );

    case ReduxActions.onSearchSuccessJobEvent:
      return jobs.copyWith(
        searchResults: _sort(action.payload, jobs.sortFn),
        status: JobsStatus.success,
      );

    case ReduxActions.sortJobs:
      final _jobs = jobs.jobs;
      return jobs.copyWith(
        jobs: _sort(_jobs, action.payload),
        hasSortFn: action.payload != SortType.reset,
        sortFn: action.payload,
        status: JobsStatus.success,
      );

    case ReduxActions.onLogoutEvent:
      return JobsState.initialState();

    // case ReduxActions.addJob:
    //   List<JobModel> _jobs = new List.from(jobs.jobs)..add(action.payload);
    //   return jobs.copyWith(jobs: _jobs);

    // case ReduxActions.removeJob:
    //   List<JobModel> _jobs = jobs.jobs
    //       .where(
    //         (job) => job.id != action.payload.id,
    //       )
    //       .toList();
    //   return jobs.copyWith(jobs: _jobs);

    default:
      return jobs;
  }
}
