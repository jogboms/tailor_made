import 'package:built_collection/built_collection.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/common/middleware.dart';
import 'package:tailor_made/rebloc/extensions.dart';
import 'package:tailor_made/rebloc/measures/actions.dart';
import 'package:tailor_made/services/measures/main.dart';
import 'package:tailor_made/utils/mk_group_model_by.dart';

class MeasuresBloc extends SimpleBloc<AppState> {
  MeasuresBloc(this.measures) : assert(measures != null);

  final Measures measures;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream([
      Observable(input).whereAction<UpdateMeasureAction>().switchMap(_onUpdateMeasure(measures)),
      Observable(input).whereAction<InitMeasuresAction>().switchMap(_onInitMeasure(measures)),
    ]).untilAction<OnDisposeAction>().listen((context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _measures = state.measures;

    if (action is OnDataAction<_Union>) {
      return state.rebuild(
        (b) => b
          ..measures = _measures
              .rebuild(
                (b) => b
                  ..measures = BuiltList<MeasureModel>(action.payload.first..sort((a, b) => a.group.compareTo(b.group)))
                      .toBuilder()
                  ..grouped = action.payload.second
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    if (action is ToggleMeasuresLoading || action is UpdateMeasureAction) {
      return state.rebuild(
        (b) => b..measures = _measures.rebuild((b) => b..status = StateStatus.loading).toBuilder(),
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
      final action = context.action as UpdateMeasureAction;
      await measures.update(action.payload, action.userId);
      yield context.copyWith(InitMeasuresAction(action.userId));
    } catch (e) {
      print(e);
      yield context;
    }
  };
}

Middleware _onInitMeasure(Measures measures) {
  return (WareContext<AppState> context) {
    final userId = (context.action as InitMeasuresAction).userId;
    return measures.fetchAll(userId).map((measures) {
      if (measures.isEmpty) {
        return UpdateMeasureAction(createDefaultMeasures(), userId);
      }

      return OnDataAction<_Union>(_Union(measures, groupModelBy<MeasureModel>(measures, (measure) => measure.group)));
    }).map((action) => context.copyWith(action));
  };
}
