import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/redux/actions/main.dart';

class OnDataStatEvent extends ActionType<StatsModel> {
  OnDataStatEvent({
    StatsModel payload,
  }) : super(payload: payload);
}
