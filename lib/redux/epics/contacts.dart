import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/contacts.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';

Stream<dynamic> contacts(Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable<dynamic>(actions)
      //
      .ofType(new TypeToken<InitDataEvents>())
      .switchMap<dynamic>((InitDataEvents action) => getContactList()
          .map((contacts) => new OnDataEvent(payload: contacts))
          //
          .takeUntil<dynamic>(
              actions.where((dynamic action) => action is DisposeDataEvents)));
}

Observable<List<ContactModel>> getContactList() {
  return new Observable(CloudDb.contacts.snapshots())
      .map((QuerySnapshot snapshot) {
    return snapshot.documents
        .where((doc) => doc.data.containsKey('fullname'))
        //
        .map((item) => ContactModel.fromDoc(item))
        .toList();
  });
}
