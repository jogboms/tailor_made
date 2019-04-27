import 'package:tailor_made/models/stats.dart';

class MockModel {
  static StatsModel get stats => StatsModel(
        contacts: IntStatsModel(
          completed: 0,
          pending: 0,
          total: 0,
        ),
        gallery: IntStatsModel(
          completed: 0,
          pending: 0,
          total: 0,
        ),
        jobs: IntStatsModel(
          completed: 0,
          pending: 0,
          total: 0,
        ),
        payments: DoubleStatsModel(
          completed: 0,
          pending: 0,
          total: 0,
        ),
      );
}
