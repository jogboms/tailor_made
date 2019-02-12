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
  Stream<WareContext<AppState>> _onUpdateMeasure(
    WareContext<AppState> context,
  ) async* {
    final WriteBatch batch = CloudDb.instance.batch();

    try {
      (context.action as UpdateMeasureAction).payload.forEach((measure) {
        batch.setData(
          CloudDb.measurements.document(measure.id),
          measure.toMap(),
          merge: true,
        );
      });

      await batch.commit();
      yield context.copyWith(const InitMeasuresAction());
    } catch (e) {
      print(e);
      yield context;
    }
  }

  Stream<WareContext<AppState>> _onInitMeasure(
    WareContext<AppState> context,
  ) {
    return CloudDb.measurements.snapshots().map(
      (snapshot) {
        return snapshot.documents
            .map((item) => MeasureModel.fromDoc(item))
            .toList();
      },
    ).map((measures) {
      if (measures.isEmpty) {
        return UpdateMeasureAction(
          payload: createDefaultMeasures(),
        );
      }

      final grouped = groupModelBy<MeasureModel>(
        measures,
        (measure) => measure.group,
      );

      return OnDataMeasureAction(
        payload: measures,
        grouped: grouped,
      );
    }).map((action) => context.copyWith(action));
  }

  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    MergeStream(
      [
        Observable(input)
            .where((_) => _.action is UpdateMeasureAction)
            .switchMap(_onUpdateMeasure),
        Observable(input)
            .where((_) => _.action is InitMeasuresAction)
            .switchMap(_onInitMeasure),
      ],
    )
        .takeWhile(
          (_) => _.action is! OnDisposeAction,
        )
        .listen(
          (context) => context.dispatcher(context.action),
        );

    return input;
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

    if (action is ToggleMeasuresLoading || action is UpdateMeasureAction) {
      return state.copyWith(
        measures: _measures.copyWith(
          status: MeasuresStatus.loading,
        ),
      );
    }

    return state;
  }
}
