import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/redux/actions/jobs.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/jobs.dart';
import 'package:tailor_made/redux/states/main.dart';

Comparator<JobModel> _sort(SortType sortType) {
  switch (sortType) {
    case SortType.active:
      return (a, b) =>
          (a.isComplete == b.isComplete) ? 0 : a.isComplete ? 1 : -1;
    case SortType.name:
      return (a, b) => a.name.compareTo(b.name);
    case SortType.payments:
      final _folder =
          (double value, PaymentModel element) => value + element.price;
      return (a, b) => b.payments.fold<double>(0.0, _folder).compareTo(
            a.payments.fold<double>(0.0, _folder),
          );
    case SortType.owed:
      return (a, b) => b.pendingPayment.compareTo(a.pendingPayment);
    case SortType.price:
      return (a, b) => b.price.compareTo(a.price);
    case SortType.recent:
      return (a, b) => b.createdAt.compareTo(a.createdAt);
    case SortType.reset:
    default:
      return (a, b) => a.id.compareTo(b.id);
  }
}

JobsState reducer(ReduxState state, ActionType action) {
  final JobsState jobs = state.jobs;

  switch (action.type) {
    case ReduxActions.initJobs:
    case ReduxActions.onDataEventJob:
      return jobs.copyWith(
        jobs: List<JobModel>.of(action.payload)..sort(_sort(jobs.sortFn)),
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
        searchResults: List<JobModel>.of(action.payload)
          ..sort(_sort(jobs.sortFn)),
        status: JobsStatus.success,
      );

    case ReduxActions.sortJobs:
      return jobs.copyWith(
        jobs: List<JobModel>.of(jobs.jobs)..sort(_sort(action.payload)),
        hasSortFn: action.payload != SortType.reset,
        sortFn: action.payload,
        status: JobsStatus.success,
      );

    default:
      return jobs;
  }
}
