import 'package:built_collection/built_collection.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/measures/actions.dart';
import 'package:tailor_made/utils/mk_group_model_by.dart';

class MeasuresBloc extends SimpleBloc<AppState> {
  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream([
      Observable(input).where((context) => context.action is UpdateMeasureAction).switchMap(_onUpdateMeasure),
      Observable(input).where((context) => context.action is InitMeasuresAction).switchMap(_onInitMeasure),
    ])
        .takeWhile((context) => context.action is! OnDisposeAction)
        .listen((context) => context.dispatcher(context.action));

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

Stream<WareContext<AppState>> _onUpdateMeasure(WareContext<AppState> context) async* {
  try {
    await Dependencies.di()
        .measures
        .update((context.action as UpdateMeasureAction).payload, Dependencies.di().session.user.getId());
    yield context.copyWith(const InitMeasuresAction());
  } catch (e) {
    print(e);
    yield context;
  }
}

Stream<WareContext<AppState>> _onInitMeasure(WareContext<AppState> context) {
  return Dependencies.di().measures.fetchAll(Dependencies.di().session.user.getId()).map((measures) {
    if (measures.isEmpty) {
      return UpdateMeasureAction(payload: createDefaultMeasures());
    }

    return OnDataAction<_Union>(
      payload: _Union(measures, groupModelBy<MeasureModel>(measures, (measure) => measure.group)),
    );
  }).map((action) => context.copyWith(action));
}
