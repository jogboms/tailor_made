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
    return Observable(input).map(
      (context) {
        final _action = context.action;

        if (_action is OnReadNotice) {
          Observable.fromFuture(
            _readNotice(_action.payload).catchError(
              (dynamic e) => print(e),
            ),
          ).take(1).listen(
                (_) => context.dispatcher(VoidAction()),
              );
        }

        if (_action is OnSendRating) {
          Observable.fromFuture(
            _sendRating(_action.payload, _action.rating).catchError(
              (dynamic e) => print(e),
            ),
          ).take(1).listen(
                (_) => context.dispatcher(VoidAction()),
              );
        }

        if (_action is OnPremiumSignUp) {
          Observable.fromFuture(_signUp(_action.payload).catchError(
            (dynamic e) => print(e),
          )).take(1).listen(
                (_) => context.dispatcher(VoidAction()),
              );
        }

        if (_action is InitDataAction) {
          Observable(CloudDb.account.snapshots())
              .map((snapshot) => AccountModel.fromDoc(snapshot))
              .takeUntil<dynamic>(
                input.where((action) => action is DisposeDataAction),
              )
              .listen(
                (account) =>
                    context.dispatcher(OnDataAccountAction(payload: account)),
              );
        }

        return context;
      },
    );
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
