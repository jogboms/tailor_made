import 'package:tailor_made/models/mock.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/services/stats/stats.dart';

class StatsMockImpl extends Stats {
  @override
  Stream<StatsModel> fetch(String userId) async* {
    yield MockModel.stats;
  }
}
