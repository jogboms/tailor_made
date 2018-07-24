import 'package:tailor_made/models/settings.dart';

class Settings {
  static SettingsModel _settings;
  static String _versionName;

  Settings._();

  static void setData(SettingsModel data) => _settings = data;

  static SettingsModel getData() => _settings;

  static void setVersion(String version) => _versionName = version;

  static String getVersion() => _versionName;
}
