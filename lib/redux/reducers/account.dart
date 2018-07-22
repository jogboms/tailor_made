import 'package:tailor_made/redux/actions/account.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/account.dart';

AccountState reducer(AccountState account, ActionType action) {
  if (action is OnDataAccountEvent) {
    return account.copyWith(
      account: action.payload,
      status: AccountStatus.success,
    );
  }

  if (action is OnSkipedPremium) {
    return account.copyWith(
      hasSkipedPremium: true,
    );
  }

  return account;
}
