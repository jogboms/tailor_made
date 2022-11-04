import 'package:tailor_made/models/stats/stats.dart';

abstract class Stats {
  Stream<StatsModel?> fetch(String? userId);
}
