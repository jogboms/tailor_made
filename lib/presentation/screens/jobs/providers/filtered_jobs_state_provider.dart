import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';
import '../../../utils.dart';

part 'filtered_jobs_state_provider.g.dart';

@Riverpod(dependencies: <Object>[account, jobs, SearchJobQueryState, SearchJobSortState])
Future<FilteredJobsState> filteredJobs(FilteredJobsRef ref) async {
  final List<JobEntity> items = await ref.watch(jobsProvider.future);
  final String query = ref.watch(searchJobQueryStateProvider).trim().toLowerCase();
  final JobsSortType sortType = ref.watch(searchJobSortStateProvider);

  return FilteredJobsState(
    jobs: items
        .where((JobEntity element) {
          if (query.length > 1) {
            return element.name.contains(RegExp(query, caseSensitive: false));
          }

          return true;
        })
        .sorted(_sort(sortType))
        .toList(growable: false),
  );
}

class FilteredJobsState with EquatableMixin {
  const FilteredJobsState({required this.jobs});

  final List<JobEntity> jobs;

  @override
  List<Object> get props => <Object>[jobs];
}

@riverpod
class SearchJobQueryState extends _$SearchJobQueryState with StateNotifierMixin {
  @override
  String build() => '';

  bool get isSearching => state.length > 1;
}

@riverpod
class SearchJobSortState extends _$SearchJobSortState with StateNotifierMixin {
  @override
  JobsSortType build() => JobsSortType.names;
}

Comparator<JobEntity> _sort(JobsSortType sortType) {
  switch (sortType) {
    case JobsSortType.active:
      return (JobEntity a, JobEntity b) => (a.isComplete == b.isComplete)
          ? 0
          : a.isComplete
              ? 1
              : -1;
    case JobsSortType.names:
      return (JobEntity a, JobEntity b) => a.name.compareTo(b.name);
    case JobsSortType.payments:
      double foldPrice(double acc, PaymentEntity model) => acc + model.price;
      return (JobEntity a, JobEntity b) =>
          b.payments.fold<double>(0.0, foldPrice).compareTo(a.payments.fold<double>(0.0, foldPrice));
    case JobsSortType.owed:
      return (JobEntity a, JobEntity b) => b.pendingPayment.compareTo(a.pendingPayment);
    case JobsSortType.price:
      return (JobEntity a, JobEntity b) => b.price.compareTo(a.price);
    case JobsSortType.recent:
      return (JobEntity a, JobEntity b) => b.createdAt.compareTo(a.createdAt);
    case JobsSortType.reset:
      return (JobEntity a, JobEntity b) => a.id.compareTo(b.id);
  }
}
