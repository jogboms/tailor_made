import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'sort_type.g.dart';

class SortType extends EnumClass {
  const SortType._(String name) : super(name);

  static const SortType recent = _$recent;
  static const SortType active = _$active;
  static const SortType names = _$names;
  static const SortType owed = _$owed;
  static const SortType payments = _$payments;
  static const SortType price = _$price;
  static const SortType reset = _$reset;

  static Serializer<SortType> get serializer => _$sortTypeSerializer;

  static BuiltSet<SortType> get values => _$values;

  static SortType valueOf(String name) => _$valueOf(name);
}
