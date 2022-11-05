import 'dart:async';

import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/rebloc/accounts/actions.dart';
import 'package:tailor_made/rebloc/accounts/state.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/common/middleware.dart';
import 'package:tailor_made/rebloc/extensions.dart';
import 'package:tailor_made/services/accounts/main.dart';

class AccountBloc extends SimpleBloc<AppState> {
  AccountBloc(this.accounts);

  final Accounts accounts;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream<WareContext<AppState>>(<Stream<WareContext<AppState>>>[
      input.whereAction<InitAccountAction>().switchMap(_getAccount(accounts)),
      input.whereAction<OnReadNotice>().switchMap(_readNotice(accounts)),
      input.whereAction<OnSendRating>().switchMap(_sendRating(accounts)),
      input.whereAction<OnPremiumSignUp>().switchMap(_signUp(accounts)),
    ]).untilAction<OnDisposeAction>().listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final AccountState account = state.account;

    if (action is OnDataAction<AccountModel>) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..account = account
              .rebuild(
                (AccountStateBuilder b) => b
                  ..account = action.payload.toBuilder()
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    if (action is OnSkipedPremium) {
      return state.rebuild(
        (AppStateBuilder b) =>
            b..account = account.rebuild((AccountStateBuilder b) => b..hasSkipedPremium = true).toBuilder(),
      );
    }

    return state;
  }
}

Middleware _readNotice(Accounts accounts) {
  return (WareContext<AppState> context) async* {
    await accounts.readNotice(
      (context.action as OnReadNotice).payload!.rebuild((AccountModelBuilder b) => b..hasReadNotice = true),
    );

    yield context;
  };
}

Middleware _sendRating(Accounts accounts) {
  return (WareContext<AppState> context) async* {
    final OnSendRating action = context.action as OnSendRating;
    final AccountModel account = action.account!.rebuild(
      (AccountModelBuilder b) => b
        ..hasSendRating = true
        ..rating = action.rating,
    );
    await accounts.sendRating(account);

    yield context;
  };
}

Middleware _signUp(Accounts accounts) {
  return (WareContext<AppState> context) async* {
    final AccountModel account = (context.action as OnPremiumSignUp).payload!.rebuild(
          (AccountModelBuilder b) => b
            ..status = AccountModelStatus.pending
            ..notice = context.state.settings.settings!.premiumNotice
            ..hasReadNotice = false
            ..hasPremiumEnabled = true,
        );
    await accounts.signUp(account);

    yield context;
  };
}

Middleware _getAccount(Accounts accounts) {
  return (WareContext<AppState> context) {
    return accounts
        .getAccount((context.action as InitAccountAction).userId)
        .map(OnDataAction<AccountModel>.new)
        .map((OnDataAction<AccountModel> action) => context.copyWith(action));
  };
}
