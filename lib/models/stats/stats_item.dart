import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/serializers.dart';

part 'stats_item.g.dart';

abstract class StatsItemModel<T extends num>
    with ModelInterface
    implements Built<StatsItemModel<T>, StatsItemModelBuilder<T>> {
  factory StatsItemModel([void Function(StatsItemModelBuilder<T> b) updates]) = _$StatsItemModel<T>;

  StatsItemModel._();

  static void _initializeBuilder<U extends num>(StatsItemModelBuilder<U> b) => b
    ..total = U == int ? 0 as U? : 0.0 as U?
    ..pending = U == int ? 0 as U? : 0.0 as U?
    ..completed = U == int ? 0 as U? : 0.0 as U?;

  T get total;

  T? get pending;

  T? get completed;

  @override
  Map<String, dynamic>? toMap() => serializers.serializeWith(StatsItemModel.serializer, this) as Map<String, dynamic>?;

  static StatsItemModel<num>? fromJson(Map<String, dynamic> map) =>
      serializers.deserializeWith(StatsItemModel.serializer, map);

  static Serializer<StatsItemModel<num>> get serializer => _$statsItemModelSerializer;
}
