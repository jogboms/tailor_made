import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/actions/stats.dart';
import 'package:tailor_made/redux/states/stats.dart';

StatsState reducer(StatsState stats, ActionType action) {
  if (action is OnDataStatEvent) {
    return stats.copyWith(
      stats: action.payload,
      status: StatsStatus.success,
    );
  }

  return stats;
}
