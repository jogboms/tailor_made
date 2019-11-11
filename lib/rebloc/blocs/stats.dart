import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/actions/stats.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/stats.dart';
import 'package:tailor_made/services/stats.dart';

class StatsBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    Observable(input)
        .where((_) => _.action is InitStatsAction)
        .switchMap(
          (context) => Stats.di()
              .fetch()
              .map((stats) => OnDataStatAction(payload: stats))
              .map((action) => context.copyWith(action)),
        )
        .takeWhile((_) => _.action is! OnDisposeAction)
        .listen((context) => context.dispatcher(context.action));

    return input;
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
