import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/actions/stats.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/states/stats.dart';

StatsState reducer(ReduxState state, ActionType action) {
  final StatsState stats = state.stats;

  if (action is InitStats || action is OnDataEvent) {
    return stats.copyWith(
      stats: action.payload,
      status: StatsStatus.success,
    );
  }

  return stats;
}
