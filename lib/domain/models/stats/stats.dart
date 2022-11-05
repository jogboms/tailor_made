import 'package:freezed_annotation/freezed_annotation.dart';

import 'stats_item.dart';

part 'stats.freezed.dart';
part 'stats.g.dart';

@freezed
class StatsModel with _$StatsModel {
  const factory StatsModel({
    required StatsItemModel jobs,
    required StatsItemModel contacts,
    required StatsItemModel gallery,
    required StatsItemModel payments,
  }) = _StatsModel;

  factory StatsModel.fromJson(Map<String, Object?> json) => _$StatsModelFromJson(json);
}

// KEEP
// {
//   'contacts': {
//     'total': 0
//   },
//   'gallery': {
//     'total': 0
//   },
//   'jobs': {
//     'total': 0,
//     'pending': 0,
//     'completed': 0,
//   },
//   'payments': {
//     'total': 0,
//     'pending': 0,
//     'completed': 0,
//   },
// }
