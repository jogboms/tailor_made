import 'package:built_collection/built_collection.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/common/middleware.dart';
import 'package:tailor_made/rebloc/extensions.dart';
import 'package:tailor_made/rebloc/measures/actions.dart';
import 'package:tailor_made/rebloc/measures/state.dart';
import 'package:tailor_made/services/measures/main.dart';
import 'package:tailor_made/utils/mk_group_model_by.dart';

class MeasuresBloc extends SimpleBloc<AppState> {
  MeasuresBloc(this.measures);

  final Measures measures;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream<WareContext<AppState>>(<Stream<WareContext<AppState>>>[
      input.whereAction<UpdateMeasureAction>().switchMap(_onUpdateMeasure(measures)),
      input.whereAction<InitMeasuresAction>().switchMap(_onInitMeasure(measures)),
    ]).untilAction<OnDisposeAction>().listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final MeasuresState measures = state.measures;

    if (action is OnDataAction<_Union<MeasureModel>>) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..measures = measures
              .rebuild(
                (MeasuresStateBuilder b) => b
                  ..measures = BuiltList<MeasureModel>(
                    action.payload.first..sort((MeasureModel a, MeasureModel b) => a.group.compareTo(b.group)),
                  ).toBuilder()
                  ..grouped = action.payload.second
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    if (action is ToggleMeasuresLoading || action is UpdateMeasureAction) {
      return state.rebuild(
        (AppStateBuilder b) =>
            b..measures = measures.rebuild((MeasuresStateBuilder b) => b..status = StateStatus.loading).toBuilder(),
      );
    }

    return state;
  }
}

class _Union<T extends MeasureModel> {
  const _Union(this.first, this.second);

  final List<T> first;
  final Map<String, List<T>> second;

  @override
  String toString() => '_Union($first, $second)';
}

Middleware _onUpdateMeasure(Measures measures) {
  return (WareContext<AppState> context) async* {
    try {
      final UpdateMeasureAction action = context.action as UpdateMeasureAction;
      await measures.update(action.payload, action.userId);
      yield context.copyWith(InitMeasuresAction(action.userId));
    } catch (e) {
      yield context;
    }
  };
}

Middleware _onInitMeasure(Measures measures) {
  return (WareContext<AppState> context) {
    final String? userId = (context.action as InitMeasuresAction).userId;
    return measures.fetchAll(userId).map((List<MeasureModel> measures) {
      if (measures.isEmpty) {
        return UpdateMeasureAction(createDefaultMeasures(), userId);
      }

      return OnDataAction<_Union<MeasureModel>>(
        _Union<MeasureModel>(measures, groupModelBy<MeasureModel>(measures, (MeasureModel measure) => measure.group)),
      );
    }).map((Action action) => context.copyWith(action));
  };
}
