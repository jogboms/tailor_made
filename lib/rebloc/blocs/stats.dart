import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/actions/stats.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/stats.dart';

class StatsBloc extends SimpleBloc<AppState> {
  @override
  AppState reducer(AppState state, Action action) {
    final _stats = state.stats;

    if (action is OnDataStatEvent) {
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
