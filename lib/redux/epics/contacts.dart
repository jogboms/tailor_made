import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/contacts.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/services/cloudstore.dart';

Stream<dynamic> contacts(Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable(actions)
      //
      .ofType(new TypeToken<InitDataEvents>())
      .switchMap((InitDataEvents action) => getContactList()
          .map((contacts) => new OnDataEvent(payload: contacts))
          //
          .takeUntil(actions.where((action) => action is DisposeDataEvents)));
}

Observable<List<ContactModel>> getContactList() {
  return new Observable(Cloudstore.contacts.snapshots()).map((QuerySnapshot snapshot) {
    return snapshot.documents
        .where((doc) => doc.data.containsKey("fullname"))
        //
        .map((item) => ContactModel.fromDoc(item))
        .toList();
  });
}
