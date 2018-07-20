import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/redux/actions/main.dart';

class InitStats extends ActionType<StatsModel> {
  @override
  final String type = ReduxActions.initStats;

  InitStats({StatsModel payload}) : super(payload: payload);
}

class OnDataEvent extends ActionType<StatsModel> {
  @override
  final String type = ReduxActions.onDataEventStat;

  OnDataEvent({StatsModel payload}) : super(payload: payload);
}
