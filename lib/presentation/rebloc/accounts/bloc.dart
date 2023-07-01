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
      input.whereAction<_OnReadNotice>().switchMap(_readNotice(accounts)),
      input.whereAction<_OnSendRating>().switchMap(_sendRating(accounts)),
    ]).listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }
}

//todo: move to accountProvider
Middleware _readNotice(Accounts accounts) {
  return (WareContext<AppState> context) async* {
    final AccountEntity account = (context.action as _OnReadNotice).payload;
    await accounts.updateAccount(
      account.uid,
      id: account.reference.id,
      path: account.reference.path,
      hasReadNotice: true,
    );

    yield context;
  };
}

//todo: move to accountProvider
Middleware _sendRating(Accounts accounts) {
  return (WareContext<AppState> context) async* {
    final _OnSendRating action = context.action as _OnSendRating;
    final AccountEntity account = action.account;
    await accounts.updateAccount(
      account.uid,
      id: account.reference.id,
      path: account.reference.path,
      hasSendRating: true,
      rating: action.rating,
    );

    yield context;
  };
}
