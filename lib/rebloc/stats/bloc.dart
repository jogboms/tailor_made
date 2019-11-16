import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/stats/actions.dart';
import 'package:tailor_made/widgets/dependencies.dart';

class StatsBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    Observable(input)
        .where((WareContext<AppState> context) => context.action is InitStatsAction)
        .switchMap(
          (context) => Dependencies.di()
              .stats
              .fetch()
              .map((stats) => OnDataAction<StatsModel>(payload: stats))
              .map((action) => context.copyWith(action)),
        )
        .takeWhile((WareContext<AppState> context) => context.action is! OnDisposeAction)
        .listen((context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _stats = state.stats;

    if (action is OnDataAction<StatsModel>) {
      return state.rebuild(
        (b) => b
          ..stats = _stats
              .rebuild((b) => b
                ..stats = action.payload.toBuilder()
                ..status = StateStatus.success)
              .toBuilder(),
      );
    }

    return state;
  }
}
