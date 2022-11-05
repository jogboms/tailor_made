import 'environment.dart';
import 'shared_prefs.dart';

const String _isFirstTimeLogin = 'IS_FIRST_TIME_LOGIN';

class FirstTimeLoginCheck {
  static Future<bool> check(Environment env) async {
    if (env == Environment.mock) {
      return true;
    }
    final bool? state = await SharedPrefs.getBool(_isFirstTimeLogin);
    if (state != false) {
      return true;
    }
    return false;
  }
}
