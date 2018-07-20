import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/redux/actions/jobs.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';

Stream<dynamic> jobs(Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<InitDataEvents>())
      .switchMap<dynamic>((InitDataEvents action) =>
          _getJobList().map<dynamic>((jobs) => new OnDataEvent(payload: jobs)))
      .takeUntil<dynamic>(
          actions.where((dynamic action) => action is DisposeDataEvents));
}

Stream<dynamic> search(Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<SearchJobEvent>())
      .map((action) => action.payload)
      .map((text) => text.trim())
      .distinct()
      .where((text) => text.length > 1)
      .debounce(const Duration(milliseconds: 750))
      .switchMap<dynamic>(
        (text) => Observable<dynamic>.just(StartSearchJobEvent())
            .concatWith([_doSearch(store.state.jobs.jobs, text)]),
      )
      .takeUntil<dynamic>(
          actions.where((dynamic action) => action is DisposeDataEvents));
}

Observable<dynamic> _doSearch(List<JobModel> jobs, String text) {
  return Observable<dynamic>.just(
    new SearchSuccessJobEvent(
      payload: jobs
          .where(
            (job) => job.name
                .contains(new RegExp(r'' + text + '', caseSensitive: false)),
          )
          .toList(),
    ),
  ).delay(Duration(seconds: 1));
}

Observable<List<JobModel>> _getJobList() {
  return new Observable(CloudDb.jobs.snapshots()).map((QuerySnapshot snapshot) {
    return snapshot.documents.map((item) => JobModel.fromDoc(item)).toList();
  });
}
