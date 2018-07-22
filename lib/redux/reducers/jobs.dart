import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/redux/actions/jobs.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/jobs.dart';

final _foldPrice = (double acc, PaymentModel model) => acc + model.price;

Comparator<JobModel> _sort(SortType sortType) {
  switch (sortType) {
    case SortType.active:
      return (a, b) =>
          (a.isComplete == b.isComplete) ? 0 : a.isComplete ? 1 : -1;
    case SortType.name:
      return (a, b) => a.name.compareTo(b.name);
    case SortType.payments:
      return (a, b) => b.payments.fold<double>(0.0, _foldPrice).compareTo(
            a.payments.fold<double>(0.0, _foldPrice),
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

JobsState reducer(JobsState jobs, ActionType action) {
  if (action is OnDataJobEvent) {
    return jobs.copyWith(
      jobs: List<JobModel>.of(action.payload)..sort(_sort(jobs.sortFn)),
      status: JobsStatus.success,
    );
  }

  if (action is StartSearchJobEvent) {
    return jobs.copyWith(
      status: JobsStatus.loading,
      isSearching: true,
    );
  }

  if (action is CancelSearchJobEvent) {
    return jobs.copyWith(
      status: JobsStatus.success,
      isSearching: false,
      searchResults: [],
    );
  }

  if (action is SearchSuccessJobEvent) {
    return jobs.copyWith(
      searchResults: List<JobModel>.of(action.payload)
        ..sort(_sort(jobs.sortFn)),
      status: JobsStatus.success,
    );
  }

  if (action is SortJobs) {
    return jobs.copyWith(
      jobs: List<JobModel>.of(jobs.jobs)..sort(_sort(action.payload)),
      hasSortFn: action.payload != SortType.reset,
      sortFn: action.payload,
      status: JobsStatus.success,
    );
  }

  return jobs;
}
