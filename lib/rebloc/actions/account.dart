import 'package:rebloc/rebloc.dart';

class AccountAsyncLoadingAction extends Action {
  const AccountAsyncLoadingAction();
}

class AccountAsyncSuccessAction extends Action {
  const AccountAsyncSuccessAction();
}

class AccountAsyncFailureAction extends Action {
  const AccountAsyncFailureAction(this.error);

  final String error;
}

class AccountAsyncInitAction extends Action {
  const AccountAsyncInitAction();
}
