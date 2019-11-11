import 'package:tailor_made/models/mock.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/services/stats.dart';

class StatsMockImpl extends Stats {
  @override
  Stream<StatsModel> fetch() async* {
    yield MockModel.stats;
  }
}
