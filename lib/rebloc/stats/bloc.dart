import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/extensions.dart';
import 'package:tailor_made/rebloc/stats/actions.dart';
import 'package:tailor_made/rebloc/stats/state.dart';
import 'package:tailor_made/services/stats/main.dart';

class StatsBloc extends SimpleBloc<AppState> {
  StatsBloc(this.stats);

  final Stats stats;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    input
        .whereAction<InitStatsAction>()
        .switchMap(
          (WareContext<AppState> context) => stats
              .fetch((context.action as InitStatsAction).userId)
              .map(OnDataAction<StatsModel?>.new)
              .map((OnDataAction<StatsModel?> action) => context.copyWith(action)),
        )
        .untilAction<OnDisposeAction>()
        .listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final StatsState stats = state.stats;

    if (action is OnDataAction<StatsModel>) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..stats = stats
              .rebuild(
                (StatsStateBuilder b) => b
                  ..stats = action.payload.toBuilder()
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    return state;
  }
}
