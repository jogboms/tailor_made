import 'package:get_version/get_version.dart';
import 'package:tailor_made/constants/mk_constants.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/utils/mk_prefs.dart';

class MkSettings {
  static SettingsModel _settings;
  static Environment environment;
  static bool isTestMode;
  static int userId;
  static String tokenKey;

  static bool get isDev => environment == Environment.DEVELOPMENT;

  static bool get isMock => environment == Environment.MOCK;

  static bool get isTesting => isTestMode;

  static String _versionName = "";
  static Future<void> initVersion() async {
    if (isMock) {
      _versionName = 'v1.0';
      return null;
    }
    return _versionName = await GetVersion.projectVersion.catchError(
      (dynamic e) => null,
    );
  }

  static void setData(SettingsModel data) => _settings = data;

  static SettingsModel getData() => _settings;

  static void setVersion(String version) => _versionName = version;

  static String getVersion() => _versionName;

  static Future<bool> checkIsFirstTime() async {
    if (isMock) {
      return true;
    }
    final state = await MkPrefs.getBool(IS_FIRST_TIME);
    if (state != false) {
      await MkPrefs.setBool(IS_FIRST_TIME, false);
      return true;
    }
    return false;
  }

  static Future<bool> checkIsFirstTimeLogin() async {
    if (isMock) {
      return true;
    }
    final state = await MkPrefs.getBool(IS_FIRST_TIME_LOGIN);
    if (state != false) {
      return true;
    }
    return false;
  }

  static Future<void> updateIsFirstTimeLogin() {
    if (isMock) {
      return Future.value();
    }
    return MkPrefs.setBool(IS_FIRST_TIME_LOGIN, false);
  }
}
