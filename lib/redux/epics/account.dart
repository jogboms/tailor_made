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

Stream<dynamic> account(Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<InitDataEvents>())
      .switchMap<dynamic>((InitDataEvents action) => _getAccount()
          .map<dynamic>((account) => new OnDataEvent(payload: account)))
      .takeUntil<dynamic>(
          actions.where((dynamic action) => action is DisposeDataEvents));
}

Stream<dynamic> onPremiumSignUp(
    Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<OnPremiumSignUp>())
      .switchMap(
        (OnPremiumSignUp action) => Observable.fromFuture(
              _signUp(action.payload).catchError(
                (dynamic e) => print(e),
              ),
            ).map((account) => new VoidAction()),
      )
      .takeUntil<dynamic>(
        actions.where((dynamic action) => action is DisposeDataEvents),
      );
}

Stream<dynamic> onReadNotice(
    Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<OnReadNotice>())
      .switchMap(
        (OnReadNotice action) => Observable.fromFuture(
              _readNotice(action.payload).catchError(
                (dynamic e) => print(e),
              ),
            ).map((account) => new VoidAction()),
      )
      .takeUntil<dynamic>(
        actions.where((dynamic action) => action is DisposeDataEvents),
      );
}

Observable<AccountModel> _getAccount() {
  return new Observable(CloudDb.account.snapshots())
      .map((DocumentSnapshot snapshot) => AccountModel.fromDoc(snapshot));
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
