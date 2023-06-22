import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'actions.dart';
part 'bloc.freezed.dart';
part 'state.dart';

class JobsBloc extends SimpleBloc<AppState> {
  JobsBloc(this.jobs);

  final Jobs jobs;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream<WareContext<AppState>>(<Stream<WareContext<AppState>>>[
      input.whereAction<_SearchJobAction>().switchMap(_makeSearch),
      input.whereAction<_InitJobsAction>().switchMap(_onAfterLogin(jobs)),
    ]).untilAction<OnDisposeAction>().listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final JobsState jobs = state.jobs;

    if (action is OnDataAction<List<JobEntity>>) {
      return state.copyWith(
        jobs: jobs.copyWith(
          jobs: List<JobEntity>.of(action.payload..sort(_sort(jobs.sortFn))),
          status: StateStatus.success,
        ),
      );
    }

    if (action is _StartSearchJobAction) {
      return state.copyWith(
        jobs: jobs.copyWith(
          status: StateStatus.loading,
          isSearching: true,
        ),
      );
    }

    if (action is _CancelSearchJobAction) {
      return state.copyWith(
        jobs: jobs.copyWith(
          status: StateStatus.success,
          isSearching: false,
          searchResults: List<JobEntity>.from(<JobEntity>[]),
        ),
      );
    }

    if (action is _SearchSuccessJobAction) {
      return state.copyWith(
        jobs: jobs.copyWith(
          searchResults: List<JobEntity>.from(action.payload..sort(_sort(jobs.sortFn))),
          status: StateStatus.success,
        ),
      );
    }

    if (action is _SortJobs) {
      return state.copyWith(
        jobs: jobs.copyWith(
          jobs: List<JobEntity>.from(jobs.jobs!.toList()..sort(_sort(action.payload))),
          hasSortFn: action.payload != JobsSortType.reset,
          sortFn: action.payload,
          status: StateStatus.success,
        ),
      );
    }

    return state;
  }
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

Stream<WareContext<AppState>> _makeSearch(WareContext<AppState> context) {
  return Stream<String>.value((context.action as _SearchJobAction).payload)
      .doOnData((_) => context.dispatcher(const JobsAction.searchStart()))
      .map<String>((String text) => text.trim())
      .distinct()
      .where((String text) => text.length > 1)
      .debounceTime(const Duration(milliseconds: 750))
      .map(
        (String text) => JobsAction.searchSuccess(
          context.state.jobs.jobs!
              .where((JobEntity job) => job.name.contains(RegExp(text, caseSensitive: false)))
              .toList(),
        ),
      )
      .takeWhile((JobsAction action) => action is! _CancelSearchJobAction)
      .map((JobsAction action) => context.copyWith(action));
}

Middleware _onAfterLogin(Jobs jobs) {
  return (WareContext<AppState> context) {
    return jobs
        .fetchAll((context.action as _InitJobsAction).userId)
        .map(OnDataAction<List<JobEntity>>.new)
        .map((OnDataAction<List<JobEntity>> action) => context.copyWith(action));
  };
}
