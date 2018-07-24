import 'package:tailor_made/models/settings.dart';
import 'package:version/version.dart';

class Settings {
  static SettingsModel _settings;
  static String _versionName;

  Settings._();

  static void setData(SettingsModel data) => _settings = data;

  static SettingsModel getData() => _settings;

  static void setVersion(String version) => _versionName = version;

  static String getVersion() => _versionName;

  static bool get isOutdated {
    final currentVersion = Version.parse(getVersion());
    final latestVersion = Version.parse(getData()?.versionName ?? "1.0.0");

    return latestVersion > currentVersion;
  }
}
