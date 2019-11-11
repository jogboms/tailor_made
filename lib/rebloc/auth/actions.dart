import 'package:firebase_auth/firebase_auth.dart';
import 'package:rebloc/rebloc.dart';

class OnLoginAction extends Action {
  const OnLoginAction(this.user);

  final FirebaseUser user;
}

class OnLogoutAction extends Action {
  const OnLogoutAction();
}
