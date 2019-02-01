import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/actions/measures.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/measures.dart';
import 'package:tailor_made/services/cloud_db.dart';
import 'package:tailor_made/utils/mk_group_model_by.dart';

class MeasuresBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    return Observable(input).map(
      (context) {
        final _action = context.action;

        if (_action is OnInitMeasureAction) {
          Observable.fromFuture(
            _init(_action.payload).catchError(
              (dynamic e) => print(e),
            ),
          ).take(1).listen(
                (_) => context.dispatcher(InitDataAction()),
              );
        }

        if (_action is InitDataAction) {
          Observable(CloudDb.measurements.snapshots())
              .map((snapshot) {
                return snapshot.documents
                    .map((item) => MeasureModel.fromDoc(item))
                    .toList();
              })
              .takeUntil<dynamic>(
                input.where((action) => action is DisposeDataAction),
              )
              .listen((measures) {
                if (measures.isEmpty) {
                  return context.dispatcher(OnInitMeasureAction(
                    payload: createDefaultMeasures(),
                  ));
                }

                final grouped = groupModelBy<MeasureModel>(
                  measures,
                  (measure) => measure.group,
                );

                return context.dispatcher(OnDataMeasureAction(
                  payload: measures,
                  grouped: grouped,
                ));
              });
        }

        return context;
      },
    );
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _measures = state.measures;

    if (action is OnDataMeasureAction) {
      return state.copyWith(
        measures: _measures.copyWith(
          measures: action.payload..sort((a, b) => a.group.compareTo(b.group)),
          grouped: action.grouped,
          status: MeasuresStatus.success,
        ),
      );
    }

    if (action is ToggleMeasuresLoading || action is OnInitMeasureAction) {
      return state.copyWith(
        measures: _measures.copyWith(
          status: MeasuresStatus.loading,
        ),
      );
    }

    return state;
  }
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
