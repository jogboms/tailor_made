import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/actions/jobs.dart';
import 'package:tailor_made/rebloc/states/jobs.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';

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

class JobsBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    final a = input.where((_) => _.action is SearchJobAction).asyncExpand(
          (context) => Observable<String>.just(
                  (context.action as SearchJobAction).payload)
              .map<String>((String text) => text.trim())
              .distinct()
              .where((text) => text.length > 1)
              .debounce(const Duration(milliseconds: 750))
              .switchMap<Action>(
                (text) => ConcatStream<Action>(
                      [
                        Stream.fromIterable([const StartSearchJobAction()]),
                        Observable.timer(
                          _doSearch(
                            context.state.jobs.jobs,
                            text,
                          ),
                          const Duration(seconds: 1),
                        )
                      ],
                    ).takeWhile(
                      (action) => action is! CancelSearchJobAction,
                    ),
              )
              .map((action) => context.copyWith(action)),
        );

    final b = input.where((_) => _.action is OnLoginAction).asyncExpand(
          (context) => CloudDb.jobs
              .snapshots()
              .map((snapshot) {
                return snapshot.documents
                    .map((item) => JobModel.fromDoc(item))
                    .toList();
              })
              .map((jobs) => OnDataJobAction(payload: jobs))
              .map((action) => context.copyWith(action))
              .takeWhile((_) => _.action is! OnDisposeAction),
        );

    return b;
    return MergeStream([a, b]);

    // return input.map(
    //   (context) {
    //     final _action = context.action;

    //     if (_action is SearchJobAction) {
    //       Observable<String>.just(_action.payload)
    //           .map<String>((String text) => text.trim())
    //           .distinct()
    //           .where((text) => text.length > 1)
    //           .debounce(const Duration(milliseconds: 750))
    //           .switchMap<Action>(
    //             (text) => ConcatStream<Action>(
    //                   [
    //                     Stream.fromIterable([const StartSearchJobAction()]),
    //                     Observable.timer(
    //                       _doSearch(
    //                         context.state.jobs.jobs,
    //                         text,
    //                       ),
    //                       const Duration(seconds: 1),
    //                     )
    //                   ],
    //                 ).takeWhile(
    //                   (action) => action is! CancelSearchJobAction,
    //                 ),
    //           )
    //           .listen((action) => context.dispatcher(action));
    //     }

    //     if (_action is OnInitAction) {
    //       CloudDb.jobs
    //           .snapshots()
    //           .map((snapshot) {
    //             return snapshot.documents
    //                 .map((item) => JobModel.fromDoc(item))
    //                 .toList();
    //           })
    //           .takeWhile((WareContext<AppState> context) => context.action is! OnDisposeAction)
    //           .listen(
    //             (jobs) => context.dispatcher(OnDataJobAction(payload: jobs)),
    //           );
    //     }

    //     return context;
    //   },
    // );
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _jobs = state.jobs;

    if (action is OnDataJobAction) {
      return state.copyWith(
        jobs: _jobs.copyWith(
          jobs: List<JobModel>.of(action.payload)..sort(_sort(_jobs.sortFn)),
          status: JobsStatus.success,
        ),
      );
    }

    if (action is StartSearchJobAction) {
      return state.copyWith(
        jobs: _jobs.copyWith(
          status: JobsStatus.loading,
          isSearching: true,
        ),
      );
    }

    if (action is CancelSearchJobAction) {
      return state.copyWith(
        jobs: _jobs.copyWith(
          status: JobsStatus.success,
          isSearching: false,
          searchResults: [],
        ),
      );
    }

    if (action is SearchSuccessJobAction) {
      return state.copyWith(
        jobs: _jobs.copyWith(
          searchResults: List<JobModel>.of(action.payload)
            ..sort(_sort(_jobs.sortFn)),
          status: JobsStatus.success,
        ),
      );
    }

    if (action is SortJobs) {
      return state.copyWith(
        jobs: _jobs.copyWith(
          jobs: List<JobModel>.of(_jobs.jobs)..sort(_sort(action.payload)),
          hasSortFn: action.payload != SortType.reset,
          sortFn: action.payload,
          status: JobsStatus.success,
        ),
      );
    }

    return state;
  }
}

SearchSuccessJobAction _doSearch(List<JobModel> jobs, String text) {
  return SearchSuccessJobAction(
    payload: jobs
        .where((job) => job.name.contains(
              RegExp(r'' + text + '', caseSensitive: false),
            ))
        .toList(),
  );
}
