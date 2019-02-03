import 'package:firebase_auth/firebase_auth.dart';
import 'package:rebloc/rebloc.dart';

class OnInitAction extends Action {
  const OnInitAction();
}

class OnDisposeAction extends Action {
  const OnDisposeAction();
}

class OnLoginAction extends Action {
  const OnLoginAction(this.user);

  final FirebaseUser user;
}

class OnLogoutAction extends Action {
  const OnLogoutAction();
}

class VoidAction extends Action {
  const VoidAction();
}
