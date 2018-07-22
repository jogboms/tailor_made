import 'package:tailor_made/redux/actions/account.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/account.dart';
import 'package:tailor_made/redux/states/main.dart';

AccountState reducer(ReduxState state, ActionType action) {
  final AccountState account = state.account;

  if (action is InitAccount || action is OnDataEvent) {
    return account.copyWith(
      account: action.payload,
      status: AccountStatus.success,
    );
  }

  if (action is OnSkipedPremium) {
    return account.copyWith(
      hasSkipedPremium: action.payload,
    );
  }

  return account;
}
