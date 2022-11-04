import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/repository/models.dart';

class OnLoginAction extends Action {
  const OnLoginAction(this.user);

  final User? user;
}

class OnLogoutAction extends Action {
  const OnLogoutAction();
}
