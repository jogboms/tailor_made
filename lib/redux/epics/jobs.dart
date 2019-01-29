import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/redux/actions/jobs.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';

Stream<dynamic> jobs(
  Stream<dynamic> actions,
  EpicStore<AppState> store,
) {
  return Observable<dynamic>(actions)
      .ofType(TypeToken<InitDataEvents>())
      .switchMap<dynamic>(
        (InitDataEvents action) => _getJobList()
            .map<dynamic>((jobs) => OnDataJobEvent(payload: jobs))
            .takeUntil<dynamic>(
                actions.where((dynamic action) => action is DisposeDataEvents)),
      );
}

Stream<dynamic> search(Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable<dynamic>(actions)
      .ofType(TypeToken<SearchJobEvent>())
      .map((action) => action.payload)
      .map((text) => text.trim())
      .distinct()
      .where((text) => text.length > 1)
      .debounce(const Duration(milliseconds: 750))
      .switchMap<dynamic>(
        (text) => Observable.concat([
              Observable.just(StartSearchJobEvent()),
              Observable.timer(
                _doSearch(
                  store.state.jobs.jobs,
                  text,
                ),
                Duration(seconds: 1),
              )
            ]).takeUntil<dynamic>(
              actions.where((dynamic action) => action is CancelSearchJobEvent),
            ),
      );
}

SearchSuccessJobEvent _doSearch(List<JobModel> jobs, String text) {
  return SearchSuccessJobEvent(
    payload: jobs
        .where((job) => job.name.contains(
              RegExp(r'' + text + '', caseSensitive: false),
            ))
        .toList(),
  );
}

Observable<List<JobModel>> _getJobList() {
  return Observable(CloudDb.jobs.snapshots()).map((QuerySnapshot snapshot) {
    return snapshot.documents.map((item) => JobModel.fromDoc(item)).toList();
  });
}
