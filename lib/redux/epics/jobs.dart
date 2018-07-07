import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/redux/actions/jobs.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/services/cloudstore.dart';

Stream<dynamic> jobs(Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable(actions)
      //
      .ofType(new TypeToken<InitDataEvents>())
      .switchMap((InitDataEvents action) => getJobList()
          .map((jobs) => new OnDataEvent(payload: jobs))
          //
          .takeUntil(actions.where((action) => action is DisposeDataEvents)));
}

Stream<dynamic> toggleCompleteJob(Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable(actions)
      //
      .ofType(new TypeToken<ToggleCompleteJob>())
      .flatMap((action) => Observable.fromFuture(action.payload.reference
              //
              .updateData({"isComplete": !action.payload.isComplete})
              //
              .then((_) => new VoidAction()))
          // .catchError((error) => new CounterOnErrorEventAction(error)));
          );
}

Observable<List<JobModel>> getJobList() {
  return new Observable(Cloudstore.jobs.snapshots()).map((QuerySnapshot snapshot) {
    return snapshot.documents.map((item) => JobModel.fromDoc(item)).toList();
  });
}
