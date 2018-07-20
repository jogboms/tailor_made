import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/redux/actions/main.dart';

class InitAccount extends ActionType<AccountModel> {
  @override
  final String type = ReduxActions.initAccount;

  InitAccount({AccountModel payload}) : super(payload: payload);
}

class OnDataEvent extends ActionType<AccountModel> {
  @override
  final String type = ReduxActions.onDataEventAccount;

  OnDataEvent({AccountModel payload}) : super(payload: payload);
}

class OnPremiumSignUp extends ActionType<AccountModel> {
  @override
  final String type = ReduxActions.onPremiumSignUp;

  OnPremiumSignUp({AccountModel payload}) : super(payload: payload);
}

class OnReadNotice extends ActionType<AccountModel> {
  @override
  final String type = ReduxActions.onReadNotice;

  OnReadNotice({AccountModel payload}) : super(payload: payload);
}

class OnSkipedPremium extends ActionType<bool> {
  @override
  final String type = ReduxActions.onHasSkipedPremium;

  OnSkipedPremium({bool payload}) : super(payload: payload);
}
