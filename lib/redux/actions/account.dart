import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/redux/actions/main.dart';

class OnDataAccountEvent extends ActionType<AccountModel> {
  OnDataAccountEvent({
    AccountModel payload,
  }) : super(payload: payload);
}

class OnPremiumSignUp extends ActionType<AccountModel> {
  OnPremiumSignUp({
    AccountModel payload,
  }) : super(payload: payload);
}

class OnReadNotice extends ActionType<AccountModel> {
  OnReadNotice({
    AccountModel payload,
  }) : super(payload: payload);
}

class OnSkipedPremium extends ActionType<void> {}
