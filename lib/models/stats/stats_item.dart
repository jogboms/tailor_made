import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/serializers.dart';

part 'stats_item.g.dart';

abstract class StatsItemModel<T extends num>
    with ModelInterface
    implements Built<StatsItemModel<T>, StatsItemModelBuilder<T>> {
  factory StatsItemModel([void updates(StatsItemModelBuilder<T> b)]) = _$StatsItemModel<T>;

  StatsItemModel._();

  static void _initializeBuilder<U extends num>(StatsItemModelBuilder<U> b) => b
    ..total = U == int ? 0 : 0.0
    ..pending = U == int ? 0 : 0.0
    ..completed = U == int ? 0 : 0.0;

  T get total;

  @nullable
  T get pending;

  @nullable
  T get completed;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(StatsItemModel.serializer, this);

  static StatsItemModel fromJson(Map<String, dynamic> map) =>
      serializers.deserializeWith(StatsItemModel.serializer, map);

  static Serializer<StatsItemModel> get serializer => _$statsItemModelSerializer;
}
