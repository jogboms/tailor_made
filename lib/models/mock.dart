import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/models/stats/stats_item.dart';

class MockModel {
  static StatsModel get stats => StatsModel(
        (StatsModelBuilder b) => b
          ..contacts = StatsItemModel<int>(
            (StatsItemModelBuilder<int> b) => b
              ..completed = 0
              ..pending = 0
              ..total = 0,
          ).toBuilder()
          ..gallery = StatsItemModel<int>(
            (StatsItemModelBuilder<int> b) => b
              ..completed = 0
              ..pending = 0
              ..total = 0,
          ).toBuilder()
          ..jobs = StatsItemModel<int>(
            (StatsItemModelBuilder<int> b) => b
              ..completed = 0
              ..pending = 0
              ..total = 0,
          ).toBuilder()
          ..payments = StatsItemModel<double>(
            (StatsItemModelBuilder<double> b) => b
              ..completed = 0
              ..pending = 0
              ..total = 0,
          ).toBuilder(),
      );
}
