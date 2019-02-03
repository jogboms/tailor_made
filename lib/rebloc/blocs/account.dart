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
  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    final a = input.where((_) => _.action is OnLoginAction).asyncExpand(
          (context) => CloudDb.account
              .snapshots()
              .map((snapshot) => AccountModel.fromDoc(snapshot))
              .map((account) => OnDataAccountAction(payload: account))
              .map((action) => context.copyWith(action))
              .takeWhile((_) => _.action is! OnDisposeAction),
        );

    final b = input.where((_) => _.action is OnReadNotice).asyncMap(
          (context) => _readNotice((context.action as OnReadNotice).payload)
              .catchError((dynamic e) => print(e))
              .then((_) => context),
        );

    final c = input.where((_) => _.action is OnSendRating).asyncMap(
          (context) => _readNotice((context.action as OnSendRating).payload)
              .catchError((dynamic e) => print(e))
              .then((_) => context),
        );

    final d = input.where((_) => _.action is OnPremiumSignUp).asyncMap(
          (context) => _signUp((context.action as OnPremiumSignUp).payload)
              .catchError((dynamic e) => print(e))
              .then((_) => context),
        );

    MergeStream([a, b, c, d]).listen(
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

Future<AccountModel> _sendRating(AccountModel account, int rating) async {
  final _account = account.copyWith(
    hasSendRating: true,
    rating: rating,
  );
  try {
    await account.reference.updateData(_account.toMap());
  } catch (e) {
    rethrow;
  }
  return _account;
}

Future<AccountModel> _readNotice(AccountModel account) async {
  final _account = account.copyWith(hasReadNotice: true);
  try {
    await account.reference.updateData(_account.toMap());
  } catch (e) {
    rethrow;
  }
  return _account;
}

Future<AccountModel> _signUp(AccountModel account) async {
  final _account = account.copyWith(
    status: AccountModelStatus.pending,
    notice: Settings.getData().premiumNotice,
    hasReadNotice: false,
    hasPremiumEnabled: true,
  );
  try {
    await account.reference.updateData(_account.toMap());
    await CloudDb.premium.document(account.uid).setData(_account.toMap());
  } catch (e) {
    rethrow;
  }
  return _account;
}
