import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/redux/actions/main.dart';

class InitAccount extends ActionType {
  @override
  final String type = ReduxActions.initAccount;
  final AccountModel payload;

  InitAccount({this.payload});
}

class OnDataEvent extends ActionType {
  @override
  final String type = ReduxActions.onDataEventAccount;
  final AccountModel payload;

  OnDataEvent({this.payload});
}

class OnPremiumSignUp extends ActionType {
  @override
  final String type = ReduxActions.onPremiumSignUp;
  final AccountModel payload;

  OnPremiumSignUp({
    @required this.payload,
  });
}

class OnReadNotice extends ActionType {
  @override
  final String type = ReduxActions.onReadNotice;
  final AccountModel payload;

  OnReadNotice({
    @required this.payload,
  });
}

class OnSkipedPremium extends ActionType {
  @override
  final String type = ReduxActions.onHasSkipedPremium;
  final bool payload = true;
}
