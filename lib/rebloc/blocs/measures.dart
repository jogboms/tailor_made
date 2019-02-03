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
    final a = input.where((_) => _.action is OnInitMeasureAction).asyncMap(
          (context) => _init((context.action as OnInitMeasureAction).payload)
              .catchError((dynamic e) => print(e))
              .then((_) => context.copyWith(const OnInitMeasuresAction())),
        );

    final b = input.where((_) => _.action is OnInitMeasuresAction).asyncExpand(
          (context) => CloudDb.measurements
              .snapshots()
              .map((snapshot) {
                return snapshot.documents
                    .map((item) => MeasureModel.fromDoc(item))
                    .toList();
              })
              .map((measures) {
                if (measures.isEmpty) {
                  return OnInitMeasureAction(
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
              })
              .map((action) => context.copyWith(action))
              .takeWhile((_) => _.action is! OnDisposeAction),
        );

    return b;
    return MergeStream([a, b]);

    // return Observable(input).map(
    //   (context) {
    //     final _action = context.action;

    //     // TODO: should really check this out
    //     if (_action is OnInitMeasureAction) {
    //       _init(_action.payload)
    //           .catchError((dynamic e) => print(e))
    //           .then((_) => context.dispatcher(const OnInitAction()));
    //     }

    //     if (_action is OnInitAction) {
    //       CloudDb.measurements
    //           .snapshots()
    //           .map((snapshot) {
    //             return snapshot.documents
    //                 .map((item) => MeasureModel.fromDoc(item))
    //                 .toList();
    //           })
    //           .takeWhile((WareContext<AppState> context) => context.action is! OnDisposeAction)
    //           .listen((measures) {
    //             if (measures.isEmpty) {
    //               return context.dispatcher(OnInitMeasureAction(
    //                 payload: createDefaultMeasures(),
    //               ));
    //             }

    //             final grouped = groupModelBy<MeasureModel>(
    //               measures,
    //               (measure) => measure.group,
    //             );

    //             return context.dispatcher(OnDataMeasureAction(
    //               payload: measures,
    //               grouped: grouped,
    //             ));
    //           });
    //     }

    //     return context;
    //   },
    // );
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
