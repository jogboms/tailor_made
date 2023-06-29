import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'actions.dart';
part 'bloc.freezed.dart';
part 'state.dart';

class StatsBloc extends SimpleBloc<AppState> {
  StatsBloc(this.stats);

  final Stats stats;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    input
        .whereAction<_InitStatsAction>()
        .switchMap(
          (WareContext<AppState> context) => stats
              .fetch((context.action as _InitStatsAction).userId)
              .map(OnDataAction<StatsEntity>.new)
              .map((OnDataAction<StatsEntity> action) => context.copyWith(action)),
        )
        .untilAction<OnDisposeAction>()
        .listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final StatsState stats = state.stats;

    if (action is OnDataAction<StatsEntity>) {
      return state.copyWith(
        stats: stats.copyWith(
          stats: action.payload,
          status: StateStatus.success,
        ),
      );
    }

    return state;
  }
}
