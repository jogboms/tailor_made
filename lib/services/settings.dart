import 'package:tailor_made/models/settings.dart';

class Settings {
  static SettingsModel _settings;

  Settings._();

  static setData(Map<String, dynamic> json) {
    _settings = SettingsModel.fromJson(json);
  }

  static SettingsModel getData() {
    return _settings;
  }
}
