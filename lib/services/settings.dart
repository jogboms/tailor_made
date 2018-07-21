import 'package:tailor_made/models/settings.dart';
import 'package:version/version.dart';

class Settings {
  static SettingsModel _settings;
  static String _versionName;

  Settings._();

  static void setData(Map<String, dynamic> json) {
    _settings = SettingsModel.fromJson(json);
  }

  static SettingsModel getData() {
    return _settings;
  }

  static void setVersion(String version) {
    _versionName = version;
  }

  static String getVersion() {
    return _versionName;
  }

  static bool get isOutdated {
    final currentVersion = Version.parse(getVersion());
    final latestVersion = Version.parse(getData()?.versionName ?? "1.0.0");

    return latestVersion > currentVersion;
  }
}
