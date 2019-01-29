import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/contacts.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';

Stream<dynamic> contacts(
  Stream<dynamic> actions,
  EpicStore<AppState> store,
) {
  return Observable<dynamic>(actions)
      .ofType(TypeToken<InitDataEvents>())
      .switchMap<dynamic>(
        (InitDataEvents action) => _getContactList()
            .map<dynamic>(
              (contacts) => OnDataContactEvent(payload: contacts),
            )
            .takeUntil<dynamic>(
              actions.where((dynamic action) => action is DisposeDataEvents),
            ),
      );
}

Stream<dynamic> search(
  Stream<dynamic> actions,
  EpicStore<AppState> store,
) {
  return Observable<dynamic>(actions)
      .ofType(TypeToken<SearchContactEvent>())
      .map((action) => action.payload)
      .map((text) => text.trim())
      .distinct()
      .where((text) => text.length > 1)
      .debounce(const Duration(milliseconds: 750))
      .switchMap<dynamic>(
        (text) => Observable.concat([
              Observable.just(StartSearchContactEvent()),
              Observable.timer(
                _doSearch(
                  store.state.contacts.contacts,
                  text,
                ),
                Duration(seconds: 1),
              )
            ]).takeUntil<dynamic>(actions
                .where((dynamic action) => action is CancelSearchContactEvent)),
      );
}

SearchSuccessContactEvent _doSearch(List<ContactModel> contacts, String text) {
  return SearchSuccessContactEvent(
    payload: contacts
        .where((contact) => contact.fullname.contains(
              RegExp(r'' + text + '', caseSensitive: false),
            ))
        .toList(),
  );
}

Observable<List<ContactModel>> _getContactList() {
  return Observable(CloudDb.contacts.snapshots()).map(
    (QuerySnapshot snapshot) {
      return snapshot.documents
          .where((doc) => doc.data.containsKey('fullname'))
          .map((item) => ContactModel.fromDoc(item))
          .toList();
    },
  );
}
