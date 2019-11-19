import 'package:built_collection/built_collection.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/extensions.dart';
import 'package:tailor_made/rebloc/jobs/actions.dart';
import 'package:tailor_made/rebloc/jobs/sort_type.dart';

class JobsBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream([
      Observable(input).whereAction<SearchJobAction>().switchMap(_makeSearch),
      Observable(input).whereAction<InitJobsAction>().switchMap(_onAfterLogin),
    ]).untilAction<OnDisposeAction>().listen((context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _jobs = state.jobs;

    if (action is OnDataAction<List<JobModel>>) {
      return state.rebuild(
        (b) => b
          ..jobs = _jobs
              .rebuild((b) => b
                ..jobs = BuiltList<JobModel>.of(action.payload..sort(_sort(_jobs.sortFn))).toBuilder()
                ..status = StateStatus.success)
              .toBuilder(),
      );
    }

    if (action is StartSearchJobAction) {
      return state.rebuild(
        (b) => b
          ..jobs = _jobs
              .rebuild((b) => b
                ..status = StateStatus.loading
                ..isSearching = true)
              .toBuilder(),
      );
    }

    if (action is CancelSearchJobAction) {
      return state.rebuild(
        (b) => b
          ..jobs = _jobs
              .rebuild((b) => b
                ..status = StateStatus.success
                ..isSearching = false
                ..searchResults = BuiltList<JobModel>(<JobModel>[]).toBuilder())
              .toBuilder(),
      );
    }

    if (action is SearchSuccessJobAction) {
      return state.rebuild(
        (b) => b
          ..jobs = _jobs
              .rebuild((b) => b
                ..searchResults = BuiltList<JobModel>.of(action.payload..sort(_sort(_jobs.sortFn))).toBuilder()
                ..status = StateStatus.success)
              .toBuilder(),
      );
    }

    if (action is SortJobs) {
      return state.rebuild(
        (b) => b
          ..jobs = _jobs
              .rebuild(
                (b) => b
                  ..jobs = BuiltList<JobModel>.of(_jobs.jobs.toList()..sort(_sort(action.payload))).toBuilder()
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
      return (a, b) => (a.isComplete == b.isComplete) ? 0 : a.isComplete ? 1 : -1;
    case SortType.names:
      return (a, b) => a.name.compareTo(b.name);
    case SortType.payments:
      final _foldPrice = (double acc, PaymentModel model) => acc + model.price;
      return (a, b) => b.payments.fold<double>(0.0, _foldPrice).compareTo(a.payments.fold<double>(0.0, _foldPrice));
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

Stream<WareContext<AppState>> _makeSearch(WareContext<AppState> context) {
  return Observable<String>.just((context.action as SearchJobAction).payload)
      .doOnData((_) => context.dispatcher(const StartSearchJobAction()))
      .map<String>((String text) => text.trim())
      .distinct()
      .where((text) => text.length > 1)
      .debounceTime(const Duration(milliseconds: 750))
      .map((text) => SearchSuccessJobAction(
            context.state.jobs.jobs
                .where((job) => job.name.contains(RegExp(r'' + text + '', caseSensitive: false)))
                .toList(),
          ))
      .takeWhile((action) => action is! CancelSearchJobAction)
      .map((action) => context.copyWith(action));
}

Stream<WareContext<AppState>> _onAfterLogin(WareContext<AppState> context) {
  return Dependencies.di()
      .jobs
      .fetchAll((context.action as InitJobsAction).userId)
      .map((jobs) => OnDataAction<List<JobModel>>(jobs))
      .map((action) => context.copyWith(action));
}
