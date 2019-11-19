import 'dart:async';

import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/rebloc/accounts/actions.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/extensions.dart';

class AccountBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream([
      Observable(input).whereAction<InitAccountAction>().switchMap(_getAccount),
      Observable(input).whereAction<OnReadNotice>().switchMap(_readNotice),
      Observable(input).whereAction<OnSendRating>().switchMap(_sendRating),
      Observable(input).whereAction<OnPremiumSignUp>().switchMap(_signUp),
    ]).untilAction<OnDisposeAction>().listen((context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _account = state.account;

    if (action is OnDataAction<AccountModel>) {
      return state.rebuild(
        (b) => b
          ..account = _account
              .rebuild((b) => b
                ..account = action.payload.toBuilder()
                ..status = StateStatus.success)
              .toBuilder(),
      );
    }

    if (action is OnSkipedPremium) {
      return state.rebuild(
        (b) => b..account = _account.rebuild((b) => b..hasSkipedPremium = true).toBuilder(),
      );
    }

    return state;
  }
}

Stream<WareContext<AppState>> _readNotice(WareContext<AppState> context) async* {
  await Dependencies.di()
      .accounts
      .readNotice((context.action as OnReadNotice).payload.rebuild((b) => b..hasReadNotice = true));

  yield context;
}

Stream<WareContext<AppState>> _sendRating(WareContext<AppState> context) async* {
  final _action = context.action as OnSendRating;
  final _account = _action.account.rebuild((b) => b
    ..hasSendRating = true
    ..rating = _action.rating);
  await Dependencies.di().accounts.sendRating(_account);

  yield context;
}

Stream<WareContext<AppState>> _signUp(WareContext<AppState> context) async* {
  final _account = (context.action as OnPremiumSignUp).payload.rebuild((b) => b
    ..status = AccountModelStatus.pending
    ..notice = context.state.settings.settings.premiumNotice
    ..hasReadNotice = false
    ..hasPremiumEnabled = true);
  await Dependencies.di().accounts.signUp(_account);

  yield context;
}

Stream<WareContext<AppState>> _getAccount(WareContext<AppState> context) {
  return Dependencies.di()
      .accounts
      .getAccount((context.action as InitAccountAction).userId)
      .map((account) => OnDataAction<AccountModel>(account))
      .map((action) => context.copyWith(action));
}
