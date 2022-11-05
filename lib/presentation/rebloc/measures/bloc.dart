import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

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
      return state.copyWith(
        measures: measures.copyWith(
          measures: List<MeasureModel>.from(
            action.payload.first..sort((MeasureModel a, MeasureModel b) => a.group.compareTo(b.group)),
          ),
          grouped: action.payload.second,
          status: StateStatus.success,
        ),
      );
    }

    if (action is ToggleMeasuresLoading || action is UpdateMeasureAction) {
      return state.copyWith(
        measures: measures.copyWith(status: StateStatus.loading),
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
        _Union<MeasureModel>(measures, groupBy<MeasureModel>(measures, (MeasureModel measure) => measure.group)),
      );
    }).map((Action action) => context.copyWith(action));
  };
}
