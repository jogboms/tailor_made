part of 'bloc.dart';

@freezed
class MeasuresAction with _$MeasuresAction, AppAction {
  const factory MeasuresAction.init(String userId) = _InitMeasuresAction;
  const factory MeasuresAction.update(Iterable<BaseMeasureEntity> payload, String userId) = _UpdateMeasureAction;
  const factory MeasuresAction.toggle() = _ToggleMeasuresLoading;
}
