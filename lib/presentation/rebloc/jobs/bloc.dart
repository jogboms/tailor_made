import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class JobsBloc extends SimpleBloc<AppState> {
  JobsBloc(this.jobs);

  final Jobs jobs;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream<WareContext<AppState>>(<Stream<WareContext<AppState>>>[
      input.whereAction<SearchJobAction>().switchMap(_makeSearch),
      input.whereAction<InitJobsAction>().switchMap(_onAfterLogin(jobs)),
    ]).untilAction<OnDisposeAction>().listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final JobsState jobs = state.jobs;

    if (action is OnDataAction<List<JobModel>>) {
      return state.copyWith(
        jobs: jobs.copyWith(
          jobs: List<JobModel>.of(action.payload..sort(_sort(jobs.sortFn))),
          status: StateStatus.success,
        ),
      );
    }

    if (action is StartSearchJobAction) {
      return state.copyWith(
        jobs: jobs.copyWith(
          status: StateStatus.loading,
          isSearching: true,
        ),
      );
    }

    if (action is CancelSearchJobAction) {
      return state.copyWith(
        jobs: jobs.copyWith(
          status: StateStatus.success,
          isSearching: false,
          searchResults: List<JobModel>.from(<JobModel>[]),
        ),
      );
    }

    if (action is SearchSuccessJobAction) {
      return state.copyWith(
        jobs: jobs.copyWith(
          searchResults: List<JobModel>.from(action.payload..sort(_sort(jobs.sortFn))),
          status: StateStatus.success,
        ),
      );
    }

    if (action is SortJobs) {
      return state.copyWith(
        jobs: jobs.copyWith(
          jobs: List<JobModel>.from(jobs.jobs!.toList()..sort(_sort(action.payload))),
          hasSortFn: action.payload != JobsSortType.reset,
          sortFn: action.payload,
          status: StateStatus.success,
        ),
      );
    }

    return state;
  }
}

Comparator<JobModel> _sort(JobsSortType sortType) {
  switch (sortType) {
    case JobsSortType.active:
      return (JobModel a, JobModel b) => (a.isComplete == b.isComplete)
          ? 0
          : a.isComplete
              ? 1
              : -1;
    case JobsSortType.names:
      return (JobModel a, JobModel b) => a.name.compareTo(b.name);
    case JobsSortType.payments:
      double foldPrice(double acc, PaymentModel model) => acc + model.price;
      return (JobModel a, JobModel b) =>
          b.payments.fold<double>(0.0, foldPrice).compareTo(a.payments.fold<double>(0.0, foldPrice));
    case JobsSortType.owed:
      return (JobModel a, JobModel b) => b.pendingPayment.compareTo(a.pendingPayment);
    case JobsSortType.price:
      return (JobModel a, JobModel b) => b.price.compareTo(a.price);
    case JobsSortType.recent:
      return (JobModel a, JobModel b) => b.createdAt.compareTo(a.createdAt);
    case JobsSortType.reset:
    // ignore: no_default_cases
    default:
      return (JobModel a, JobModel b) => a.id.compareTo(b.id);
  }
}

Stream<WareContext<AppState>> _makeSearch(WareContext<AppState> context) {
  return Stream<String>.value((context.action as SearchJobAction).payload)
      .doOnData((_) => context.dispatcher(const StartSearchJobAction()))
      .map<String>((String text) => text.trim())
      .distinct()
      .where((String text) => text.length > 1)
      .debounceTime(const Duration(milliseconds: 750))
      .map(
        (String text) => SearchSuccessJobAction(
          context.state.jobs.jobs!
              .where((JobModel job) => job.name.contains(RegExp(text, caseSensitive: false)))
              .toList(),
        ),
      )
      .takeWhile((SearchSuccessJobAction action) => action is! CancelSearchJobAction)
      .map((SearchSuccessJobAction action) => context.copyWith(action));
}

Middleware _onAfterLogin(Jobs jobs) {
  return (WareContext<AppState> context) {
    return jobs
        .fetchAll((context.action as InitJobsAction).userId)
        .map(OnDataAction<List<JobModel>>.new)
        .map((OnDataAction<List<JobModel>> action) => context.copyWith(action));
  };
}
