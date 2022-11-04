// ignore: unused_import
import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/image.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/models/payment.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/models/stats/stats.dart';
import 'package:tailor_made/models/stats/stats_item.dart';

part 'serializers.g.dart';

@SerializersFor(<Type>[
  AccountModelStatus,
  AccountModel,
  ContactModel,
  ImageModel,
  JobModel,
  MeasureModel,
  PaymentModel,
  SettingsModel,
  StatsItemModel,
  StatsModel,
])
final Serializers serializers = (_$serializers.toBuilder()
      ..add(_DateTimeSerializer())
      ..add(_AccountModelStatusSerializer())
      ..addPlugin(StandardJsonPlugin()))
    .build();

class _DateTimeSerializer implements PrimitiveSerializer<DateTime?> {
  final bool structured = false;
  @override
  final Iterable<Type> types = BuiltList<Type>(<Type>[DateTime]);
  @override
  final String wireName = 'DateTime';

  @override
  Object serialize(Serializers serializers, DateTime? dateTime, {FullType specifiedType = FullType.unspecified}) {
    return dateTime.toString();
  }

  @override
  DateTime? deserialize(Serializers serializers, Object serialized, {FullType specifiedType = FullType.unspecified}) {
    try {
      return DateTime.tryParse(serialized as String);
    } catch (e) {
      return DateTime.now();
    }
  }
}

// NOTE: had to do this to conform to data already existing in DB
class _AccountModelStatusSerializer implements PrimitiveSerializer<AccountModelStatus> {
  @override
  final Iterable<Type> types = const <Type>[AccountModelStatus];
  @override
  final String wireName = 'AccountModelStatus';

  @override
  Object serialize(
    Serializers serializers,
    AccountModelStatus object, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      object.index;

  @override
  AccountModelStatus deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) =>
      AccountModelStatus.values[int.tryParse(serialized.toString())!];
}
