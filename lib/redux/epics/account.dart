import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/redux/actions/account.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/services/settings.dart';

Stream<dynamic> account(
  Stream<dynamic> actions,
  EpicStore<ReduxState> store,
) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<InitDataEvents>())
      .switchMap<dynamic>(
        (InitDataEvents action) => _getAccount()
            .map<dynamic>((account) => new OnDataAccountEvent(payload: account))
            .takeUntil<dynamic>(
                actions.where((dynamic action) => action is DisposeDataEvents)),
      );
}

Stream<dynamic> onPremiumSignUp(
  Stream<dynamic> actions,
  EpicStore<ReduxState> store,
) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<OnPremiumSignUp>())
      .switchMap<dynamic>(
        (OnPremiumSignUp action) =>
            Observable.fromFuture(_signUp(action.payload).catchError(
              (dynamic e) => print(e),
            )).map<dynamic>((account) => new VoidAction()).take(1),
      );
}

Stream<dynamic> onSendRating(
  Stream<dynamic> actions,
  EpicStore<ReduxState> store,
) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<OnSendRating>())
      .switchMap<dynamic>(
        (OnSendRating action) => Observable.fromFuture(
              _sendRating(action.payload, action.rating).catchError(
                (dynamic e) => print(e),
              ),
            ).map<dynamic>((account) => new VoidAction()).take(1),
      );
}

Stream<dynamic> onReadNotice(
  Stream<dynamic> actions,
  EpicStore<ReduxState> store,
) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<OnReadNotice>())
      .switchMap<dynamic>(
        (OnReadNotice action) => Observable.fromFuture(
              _readNotice(action.payload).catchError(
                (dynamic e) => print(e),
              ),
            ).map<dynamic>((account) => new VoidAction()).take(1),
      );
}

Observable<AccountModel> _getAccount() {
  return new Observable(CloudDb.account.snapshots()).map(
    (DocumentSnapshot snapshot) => AccountModel.fromDoc(snapshot),
  );
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
