import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'actions.dart';
part 'bloc.freezed.dart';
part 'state.dart';

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
      return state.copyWith(
        account: account.copyWith(
          account: action.payload,
          status: StateStatus.success,
        ),
      );
    }

    if (action is OnSkipedPremium) {
      return state.copyWith(
        account: account.copyWith(hasSkipedPremium: true),
      );
    }

    return state;
  }
}

Middleware _readNotice(Accounts accounts) {
  return (WareContext<AppState> context) async* {
    await accounts.readNotice(
      (context.action as OnReadNotice).payload!.copyWith(hasReadNotice: true),
    );

    yield context;
  };
}

Middleware _sendRating(Accounts accounts) {
  return (WareContext<AppState> context) async* {
    final OnSendRating action = context.action as OnSendRating;
    final AccountModel account = action.account!.copyWith(
      hasSendRating: true,
      rating: action.rating,
    );
    await accounts.sendRating(account);

    yield context;
  };
}

Middleware _signUp(Accounts accounts) {
  return (WareContext<AppState> context) async* {
    final AccountModel account = (context.action as OnPremiumSignUp).payload!.copyWith(
          status: AccountModelStatus.pending,
          notice: context.state.settings.settings!.premiumNotice,
          hasReadNotice: false,
          hasPremiumEnabled: true,
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
