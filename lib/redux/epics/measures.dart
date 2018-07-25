import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/actions/measures.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/tm_group_model_by.dart';

Stream<dynamic> measures(Stream<dynamic> actions, EpicStore<ReduxState> store) {
  return new Observable<dynamic>(actions)
      .ofType(new TypeToken<InitDataEvents>())
      .switchMap<dynamic>(
        (InitDataEvents action) => _getMeasures().map<dynamic>(
              (measures) {
                final grouped = groupModelBy<MeasureModel>(measures, "group");

                return new OnDataMeasureEvent(
                  payload: measures,
                  grouped: grouped,
                );
              },
            ).takeUntil<dynamic>(
              actions.where((dynamic action) => action is DisposeDataEvents),
            ),
      );
}

Observable<List<MeasureModel>> _getMeasures() {
  return new Observable(CloudDb.measurements.snapshots())
      .map((QuerySnapshot snapshot) {
    return snapshot.documents
        .map((item) => MeasureModel.fromDoc(item))
        .toList();
  });
}
