import 'package:rebloc/rebloc.dart';

class OnInitAction extends Action {
  const OnInitAction();
}

class OnDisposeAction extends Action {
  const OnDisposeAction();
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

class InitDataAction extends Action {
  const InitDataAction();
}

class DisposeDataAction extends Action {
  const DisposeDataAction();
}
