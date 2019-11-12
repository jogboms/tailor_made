import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/serializers.dart';

part 'settings.g.dart';

abstract class SettingsModel with ModelInterface implements Built<SettingsModel, SettingsModelBuilder> {
  factory SettingsModel([void updates(SettingsModelBuilder b)]) = _$SettingsModel;

  SettingsModel._();

  String get premiumNotice;

  String get versionName;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(SettingsModel.serializer, this);

  static SettingsModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(SettingsModel.serializer, map);

  static Serializer<SettingsModel> get serializer => _$settingsModelSerializer;
}
