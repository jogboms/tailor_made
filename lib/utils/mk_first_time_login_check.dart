import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/wrappers/mk_prefs.dart';

const String _isFirstTimeLogin = 'IS_FIRST_TIME_LOGIN';

class MkFirstTimeLoginCheck {
  static Future<bool> check(Environment env) async {
    if (env == Environment.mock) {
      return true;
    }
    final bool? state = await MkPrefs.getBool(_isFirstTimeLogin);
    if (state != false) {
      return true;
    }
    return false;
  }
}
