import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/models/stats/stats_item.dart';

class MockModel {
  static StatsModel get stats => StatsModel(
        (b) => b
          ..contacts = StatsItemModel<int>((b) => b
            ..completed = 0
            ..pending = 0
            ..total = 0).toBuilder()
          ..gallery = StatsItemModel<int>((b) => b
            ..completed = 0
            ..pending = 0
            ..total = 0).toBuilder()
          ..jobs = StatsItemModel<int>((b) => b
            ..completed = 0
            ..pending = 0
            ..total = 0).toBuilder()
          ..payments = StatsItemModel<double>((b) => b
            ..completed = 0
            ..pending = 0
            ..total = 0).toBuilder(),
      );
}
