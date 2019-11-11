import 'dart:async';

import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/rebloc/actions/account.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/states/account.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/services/accounts.dart';

class AccountBloc extends SimpleBloc<AppState> {
  Stream<WareContext<AppState>> _readNotice(
    WareContext<AppState> context,
  ) async* {
    await Accounts.di().readNotice(
      (context.action as OnReadNotice).payload,
    );

    yield context;
  }

  Stream<WareContext<AppState>> _sendRating(
    WareContext<AppState> context,
  ) async* {
    final _action = context.action as OnSendRating;
    await Accounts.di().sendRating(_action.payload, _action.rating);

    yield context;
  }

  Stream<WareContext<AppState>> _signUp(
    WareContext<AppState> context,
  ) async* {
    await Accounts.di().signUp(
      (context.action as OnPremiumSignUp).payload,
    );

    yield context;
  }

  Stream<WareContext<AppState>> _getAccount(
    WareContext<AppState> context,
  ) {
    return Accounts.di()
        .getAccount()
        .map((account) => OnDataAccountAction(payload: account))
        .map((action) => context.copyWith(action));
  }

  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    MergeStream(
      [
        Observable(input).where((_) => _.action is InitAccountAction).switchMap(_getAccount),
        Observable(input).where((_) => _.action is OnReadNotice).switchMap(_readNotice),
        Observable(input).where((_) => _.action is OnSendRating).switchMap(_sendRating),
        Observable(input).where((_) => _.action is OnPremiumSignUp).switchMap(_signUp),
      ],
    )
        .takeWhile(
          (_) => _.action is! OnDisposeAction,
        )
        .listen(
          (context) => context.dispatcher(context.action),
        );

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _account = state.account;

    if (action is OnDataAccountAction) {
      return state.copyWith(
        account: _account.copyWith(
          account: action.payload,
          status: AccountStatus.success,
        ),
      );
    }

    if (action is OnSkipedPremium) {
      return state.copyWith(
        account: _account.copyWith(
          hasSkipedPremium: true,
        ),
      );
    }

    return state;
  }
}
