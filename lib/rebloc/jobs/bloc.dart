import 'package:built_collection/built_collection.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/common/middleware.dart';
import 'package:tailor_made/rebloc/extensions.dart';
import 'package:tailor_made/rebloc/jobs/actions.dart';
import 'package:tailor_made/rebloc/jobs/sort_type.dart';
import 'package:tailor_made/rebloc/jobs/state.dart';
import 'package:tailor_made/services/jobs/main.dart';

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
      return state.rebuild(
        (AppStateBuilder b) => b
          ..jobs = jobs
              .rebuild(
                (JobsStateBuilder b) => b
                  ..jobs = BuiltList<JobModel>.of(action.payload..sort(_sort(jobs.sortFn))).toBuilder()
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    if (action is StartSearchJobAction) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..jobs = jobs
              .rebuild(
                (JobsStateBuilder b) => b
                  ..status = StateStatus.loading
                  ..isSearching = true,
              )
              .toBuilder(),
      );
    }

    if (action is CancelSearchJobAction) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..jobs = jobs
              .rebuild(
                (JobsStateBuilder b) => b
                  ..status = StateStatus.success
                  ..isSearching = false
                  ..searchResults = BuiltList<JobModel>(<JobModel>[]).toBuilder(),
              )
              .toBuilder(),
      );
    }

    if (action is SearchSuccessJobAction) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..jobs = jobs
              .rebuild(
                (JobsStateBuilder b) => b
                  ..searchResults = BuiltList<JobModel>.of(action.payload..sort(_sort(jobs.sortFn))).toBuilder()
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    if (action is SortJobs) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..jobs = jobs
              .rebuild(
                (JobsStateBuilder b) => b
                  ..jobs = BuiltList<JobModel>.of(jobs.jobs!.toList()..sort(_sort(action.payload))).toBuilder()
                  ..hasSortFn = action.payload != SortType.reset
                  ..sortFn = action.payload
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    return state;
  }
}

Comparator<JobModel> _sort(SortType sortType) {
  switch (sortType) {
    case SortType.active:
      return (JobModel a, JobModel b) => (a.isComplete == b.isComplete)
          ? 0
          : a.isComplete!
              ? 1
              : -1;
    case SortType.names:
      return (JobModel a, JobModel b) => a.name!.compareTo(b.name!);
    case SortType.payments:
      double foldPrice(double acc, PaymentModel model) => acc + model.price;
      return (JobModel a, JobModel b) =>
          b.payments!.fold<double>(0.0, foldPrice).compareTo(a.payments!.fold<double>(0.0, foldPrice));
    case SortType.owed:
      return (JobModel a, JobModel b) => b.pendingPayment!.compareTo(a.pendingPayment!);
    case SortType.price:
      return (JobModel a, JobModel b) => b.price!.compareTo(a.price!);
    case SortType.recent:
      return (JobModel a, JobModel b) => b.createdAt!.compareTo(a.createdAt!);
    case SortType.reset:
    // ignore: no_default_cases
    default:
      return (JobModel a, JobModel b) => a.id!.compareTo(b.id!);
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
              .where((JobModel job) => job.name!.contains(RegExp(text, caseSensitive: false)))
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
