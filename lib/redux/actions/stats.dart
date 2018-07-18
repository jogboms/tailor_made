import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/redux/actions/main.dart';

class InitStats extends ActionType {
  @override
  final String type = ReduxActions.initStats;
  final StatsModel payload;

  InitStats({this.payload});
}

class OnDataEvent extends ActionType {
  @override
  final String type = ReduxActions.onDataEventStat;
  final StatsModel payload;

  OnDataEvent({this.payload});
}
