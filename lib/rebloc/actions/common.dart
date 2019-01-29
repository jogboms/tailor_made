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

class VoidAction extends Action {
  const VoidAction();
}

class OnLogoutEvent extends Action {
  const OnLogoutEvent();
}

class InitDataEvents extends Action {
  const InitDataEvents();
}

class DisposeDataEvents extends Action {
  const DisposeDataEvents();
}
