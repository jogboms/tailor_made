import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/account.dart';
import 'package:tailor_made/redux/states/main.dart';

AccountState reducer(ReduxState state, ActionType action) {
  final AccountState account = state.account;

  switch (action.type) {
    case ReduxActions.initAccount:
    case ReduxActions.onDataEventAccount:
      return account.copyWith(
        account: action.payload,
        status: AccountStatus.success,
      );

    case ReduxActions.onHasSkipedPremium:
      return account.copyWith(
        hasSkipedPremium: action.payload,
      );

    case ReduxActions.onLogoutEvent:
      return AccountState.initialState();

    default:
      return account;
  }
}
