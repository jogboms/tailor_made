import 'package:built_collection/built_collection.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/jobs/actions.dart';
import 'package:tailor_made/rebloc/jobs/sort_type.dart';
import 'package:tailor_made/services/jobs/jobs.dart';

final _foldPrice = (double acc, PaymentModel model) => acc + model.price;

Comparator<JobModel> _sort(SortType sortType) {
  switch (sortType) {
    case SortType.active:
      {
        return (a, b) => (a.isComplete == b.isComplete) ? 0 : a.isComplete ? 1 : -1;
      }
    case SortType.names:
      {
        return (a, b) => a.name.compareTo(b.name);
      }
    case SortType.payments:
      {
        return (a, b) => b.payments.fold<double>(0.0, _foldPrice).compareTo(a.payments.fold<double>(0.0, _foldPrice));
      }
    case SortType.owed:
      {
        return (a, b) => b.pendingPayment.compareTo(a.pendingPayment);
      }
    case SortType.price:
      {
        return (a, b) => b.price.compareTo(a.price);
      }
    case SortType.recent:
      {
        return (a, b) => b.createdAt.compareTo(a.createdAt);
      }
    case SortType.reset:
    default:
      {
        return (a, b) => a.id.compareTo(b.id);
      }
  }
}

class JobsBloc extends SimpleBloc<AppState> {
  Stream<WareContext<AppState>> _makeSearch(WareContext<AppState> context) {
    return Observable<String>.just((context.action as SearchJobAction).payload)
        .doOnData((_) => context.dispatcher(const StartSearchJobAction()))
        .map<String>((String text) => text.trim())
        .distinct()
        .where((text) => text.length > 1)
        .debounceTime(const Duration(milliseconds: 750))
        .map((text) => SearchSuccessJobAction(
              payload: context.state.jobs.jobs
                  .where((job) => job.name.contains(RegExp(r'' + text + '', caseSensitive: false)))
                  .toList(),
            ))
        .takeWhile((action) => action is! CancelSearchJobAction)
        .map((action) => context.copyWith(action));
  }

  Stream<WareContext<AppState>> _onAfterLogin(WareContext<AppState> context) {
    return Jobs.di()
        .fetchAll()
        .map((jobs) => OnDataAction<List<JobModel>>(payload: jobs))
        .map((action) => context.copyWith(action));
  }

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream([
      Observable(input)
          .where((WareContext<AppState> context) => context.action is SearchJobAction)
          .switchMap(_makeSearch),
      Observable(input)
          .where((WareContext<AppState> context) => context.action is InitJobsAction)
          .switchMap(_onAfterLogin),
    ])
        .takeWhile((WareContext<AppState> context) => context.action is! OnDisposeAction)
        .listen((context) => context.dispatcher(context.action));

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
