import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'actions.dart';
part 'bloc.freezed.dart';
part 'state.dart';

class MeasuresBloc extends SimpleBloc<AppState> {
  MeasuresBloc(this.measures);

  final Measures measures;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream<WareContext<AppState>>(<Stream<WareContext<AppState>>>[
      input.whereAction<_UpdateMeasureAction>().switchMap(_onUpdateMeasure(measures)),
      input.whereAction<_InitMeasuresAction>().switchMap(_onInitMeasure(measures)),
    ]).listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final MeasuresState measures = state.measures;

    if (action is OnDataAction<_Union<MeasureEntity>>) {
      return state.copyWith(
        measures: measures.copyWith(
          measures: List<MeasureEntity>.from(
            action.payload.first..sort((MeasureEntity a, MeasureEntity b) => a.group.compareTo(b.group)),
          ),
          grouped: action.payload.second,
          status: StateStatus.success,
        ),
      );
    }

    if (action is _ToggleMeasuresLoading || action is _UpdateMeasureAction) {
      return state.copyWith(
        measures: measures.copyWith(status: StateStatus.loading),
      );
    }

    return state;
  }
}

class _Union<T extends MeasureEntity> {
  const _Union(this.first, this.second);

  final List<T> first;
  final Map<MeasureGroup, List<T>> second;

  @override
  String toString() => '_Union($first, $second)';
}

Middleware _onUpdateMeasure(Measures measures) {
  return (WareContext<AppState> context) async* {
    try {
      final _UpdateMeasureAction action = context.action as _UpdateMeasureAction;
      await measures.update(action.payload, action.userId);
      yield context.copyWith(MeasuresAction.init(action.userId));
    } catch (e) {
      yield context;
    }
  };
}

Middleware _onInitMeasure(Measures measures) {
  return (WareContext<AppState> context) {
    final String userId = (context.action as _InitMeasuresAction).userId;
    return measures.fetchAll(userId).map((List<MeasureEntity> measures) {
      if (measures.isEmpty) {
        return MeasuresAction.update(BaseMeasureEntity.defaults, userId);
      }

      return OnDataAction<_Union<MeasureEntity>>(
        _Union<MeasureEntity>(
          measures,
          groupBy<MeasureGroup, MeasureEntity>(measures, (MeasureEntity measure) => measure.group),
        ),
      );
    }).map((Action action) => context.copyWith(action));
  };
}
