import 'dart:async';

import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/rebloc/actions/account.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/states/account.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/services/settings.dart';

class AccountBloc extends SimpleBloc<AppState> {
  Future<WareContext<AppState>> _readNotice(
    WareContext<AppState> context,
  ) async {
    final _account = (context.action as OnReadNotice).payload;
    try {
      await _account.reference.updateData(
        _account.copyWith(hasReadNotice: true).toMap(),
      );
    } catch (e) {
      print(e);
      rethrow;
    }
    return context;
  }

  Future<WareContext<AppState>> _sendRating(
    WareContext<AppState> context,
  ) async {
    final _action = context.action as OnSendRating;

    try {
      await _action.payload.reference.updateData(
        _action.payload
            .copyWith(hasSendRating: true, rating: _action.rating)
            .toMap(),
      );
    } catch (e) {
      print(e);
      rethrow;
    }

    return context;
  }

  Future<WareContext<AppState>> _signUp(
    WareContext<AppState> context,
  ) async {
    final _action = context.action as OnPremiumSignUp;

    try {
      final _account = _action.payload.copyWith(
        status: AccountModelStatus.pending,
        notice: Settings.getData().premiumNotice,
        hasReadNotice: false,
        hasPremiumEnabled: true,
      );
      await _action.payload.reference.updateData(_account.toMap());
      await CloudDb.premium
          .document(_action.payload.uid)
          .setData(_account.toMap());
    } catch (e) {
      print(e);
      rethrow;
    }

    return context;
  }

  Stream<WareContext<AppState>> _getAccount(
    WareContext<AppState> context,
  ) {
    return CloudDb.account
        .snapshots()
        .map((snapshot) => AccountModel.fromDoc(snapshot))
        .map((account) => OnDataAccountAction(payload: account))
        .map((action) => context.copyWith(action))
        .takeWhile((_) => _.action is! OnDisposeAction);
  }

  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    MergeStream([
      input.where((_) => _.action is InitAccountAction).asyncExpand(
            _getAccount,
          ),
      input.where((_) => _.action is OnReadNotice).asyncMap(_readNotice),
      input.where((_) => _.action is OnSendRating).asyncMap(_sendRating),
      input.where((_) => _.action is OnPremiumSignUp).asyncMap(_signUp),
    ]).listen(
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
