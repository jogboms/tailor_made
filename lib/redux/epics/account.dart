import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/redux/actions/account.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';

Stream<dynamic> account(Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable(actions)
      //
      .ofType(new TypeToken<InitDataEvents>())
      .switchMap((InitDataEvents action) => getAccount()
          .map((account) => new OnDataEvent(payload: account))
          //
          .takeUntil(actions.where((action) => action is DisposeDataEvents)));
}

Observable<AccountModel> getAccount() {
  return new Observable(CloudDb.account.snapshots()).map((DocumentSnapshot snapshot) {
    return AccountModel.fromDoc(snapshot);
  });
}
