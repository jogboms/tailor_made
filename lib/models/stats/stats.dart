import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/serializers.dart';
import 'package:tailor_made/models/stats/stats_item.dart';

part 'stats.g.dart';

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

abstract class StatsModel with ModelInterface implements Built<StatsModel, StatsModelBuilder> {
  factory StatsModel([void updates(StatsModelBuilder b)]) = _$StatsModel;

  StatsModel._();

  StatsItemModel<int> get jobs;

  StatsItemModel<int> get contacts;

  StatsItemModel<int> get gallery;

  StatsItemModel<double> get payments;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(StatsModel.serializer, this);

  static StatsModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(StatsModel.serializer, map);

  static Serializer<StatsModel> get serializer => _$statsModelSerializer;
}
