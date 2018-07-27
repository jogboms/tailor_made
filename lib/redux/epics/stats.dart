import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/actions/stats.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';

Stream<dynamic> stats(
  Stream<dynamic> actions,
  EpicStore<ReduxState> store,
) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<InitDataEvents>())
      .switchMap<dynamic>(
        (InitDataEvents action) => _getStats()
            .map<dynamic>((stats) => new OnDataStatEvent(payload: stats))
            .takeUntil<dynamic>(
                actions.where((dynamic action) => action is DisposeDataEvents)),
      );
}

Observable<StatsModel> _getStats() {
  return new Observable(CloudDb.stats.snapshots()).map(
    (DocumentSnapshot snapshot) => StatsModel.fromJson(snapshot.data),
  );
}
