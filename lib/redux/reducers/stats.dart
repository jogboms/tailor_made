import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/states/stats.dart';

StatsState reducer(ReduxState state, ActionType action) {
  final StatsState stats = state.stats;

  switch (action.type) {
    case ReduxActions.initStats:
    case ReduxActions.onDataEventStat:
      return stats.copyWith(
        stats: action.payload,
        status: StatsStatus.success,
      );

    default:
      return stats;
  }
}
