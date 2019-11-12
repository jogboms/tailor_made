import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/stats/stats.dart';

class InitStatsAction extends Action {
  const InitStatsAction();
}

class OnDataStatAction extends Action {
  const OnDataStatAction({@required this.payload});

  final StatsModel payload;
}
