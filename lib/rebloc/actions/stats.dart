import 'package:rebloc/rebloc.dart';

class StatsInitAction extends Action {
  const StatsInitAction();
}

class StatsUpdateAction extends Action {
  const StatsUpdateAction(this.stats);

  final dynamic stats;
}
