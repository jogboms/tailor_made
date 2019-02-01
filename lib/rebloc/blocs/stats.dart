import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/actions/stats.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/stats.dart';
import 'package:tailor_made/services/cloud_db.dart';

class StatsBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    return Observable(input).map(
      (context) {
        if (context.action is OnInitAction) {
          Observable(CloudDb.stats.snapshots())
              .map(
                (snapshot) => StatsModel.fromJson(snapshot.data),
              )
              .takeUntil<dynamic>(
                input.where((dynamic action) => action is OnDisposeAction),
              )
              .listen(
                (stats) => context.dispatcher(OnDataStatAction(payload: stats)),
              );
        }
        return context;
      },
    );
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _stats = state.stats;

    if (action is OnDataStatAction) {
      return state.copyWith(
        stats: _stats.copyWith(
          stats: action.payload,
          status: StatsStatus.success,
        ),
      );
    }

    return state;
  }
}
