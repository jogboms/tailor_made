import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class SettingsModel with _$SettingsModel {
  const factory SettingsModel({
    required String premiumNotice,
    required String versionName,
  }) = _SettingsModel;

  factory SettingsModel.fromJson(Map<String, Object?> json) => _$SettingsModelFromJson(json);
}
