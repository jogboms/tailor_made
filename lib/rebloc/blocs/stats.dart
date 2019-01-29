import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/actions/stats.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/stats.dart';

class StatsBloc extends SimpleBloc<AppState> {
  @override
  AppState reducer(AppState state, Action action) {
    final _stats = state.stats;

    if (action is StatsUpdateAction) {
      return state.copyWith(
        stats: _stats.copyWith(
          stats: action.stats,
          status: StatsStatus.success,
        ),
      );
    }

    return state;
  }
}
