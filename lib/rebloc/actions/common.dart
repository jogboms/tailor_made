import 'package:rebloc/rebloc.dart';

class OnInitAction extends Action {
  const OnInitAction();
}

class OnLoginAction extends Action {
  const OnLoginAction(this.user);

  final dynamic user;
}

class OnLogoutAction extends Action {
  const OnLogoutAction();
}
