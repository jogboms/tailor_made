import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/actions/measures.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/tm_group_model_by.dart';

Stream<dynamic> measures(
  Stream<dynamic> actions,
  EpicStore<AppState> store,
) {
  return Observable<dynamic>(actions)
      .ofType(TypeToken<InitDataEvents>())
      .switchMap<dynamic>(
        (InitDataEvents action) => _getMeasures().map<dynamic>(
              (measures) {
                if (measures.isEmpty) {
                  return OnInitMeasureEvent(
                    payload: createDefaultMeasures(),
                  );
                }

                final grouped = groupModelBy<MeasureModel>(
                  measures,
                  (measure) => measure.group,
                );

                return OnDataMeasureEvent(
                  payload: measures,
                  grouped: grouped,
                );
              },
            ).takeUntil<dynamic>(
              actions.where((dynamic action) => action is DisposeDataEvents),
            ),
      );
}

Stream<dynamic> init(
  Stream<dynamic> actions,
  EpicStore<AppState> store,
) {
  return Observable<dynamic>(actions)
      .ofType(TypeToken<OnInitMeasureEvent>())
      .switchMap<dynamic>(
        (OnInitMeasureEvent action) => Observable.fromFuture(
              _init(action.payload).catchError(
                (dynamic e) => print(e),
              ),
            )
                // TODO refactor need to InitDataEvent
                .map<dynamic>((measures) => InitDataEvents())
                .take(1),
      );
}

Future<void> _init(List<MeasureModel> measures) async {
  final WriteBatch batch = CloudDb.instance.batch();

  measures.forEach((measure) {
    batch.setData(
      CloudDb.measurements.document(measure.id),
      measure.toMap(),
      merge: true,
    );
  });

  try {
    await batch.commit();
  } catch (e) {
    rethrow;
  }
}

Observable<List<MeasureModel>> _getMeasures() {
  return Observable(CloudDb.measurements.snapshots()).map(
    (QuerySnapshot snapshot) {
      return snapshot.documents
          .map((item) => MeasureModel.fromDoc(item))
          .toList();
    },
  );
}
