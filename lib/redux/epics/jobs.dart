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
      //
      .ofType(new TypeToken<InitDataEvents>())
      .switchMap<dynamic>((InitDataEvents action) => getJobList()
          .map((jobs) => new OnDataEvent(payload: jobs))
          //
          .takeUntil<dynamic>(
              actions.where((dynamic action) => action is DisposeDataEvents)));
}

Observable<List<JobModel>> getJobList() {
  return new Observable(CloudDb.jobs.snapshots()).map((QuerySnapshot snapshot) {
    return snapshot.documents.map((item) => JobModel.fromDoc(item)).toList();
  });
}
