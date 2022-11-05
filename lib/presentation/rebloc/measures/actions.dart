part of 'bloc.dart';

@freezed
class MeasuresAction with _$MeasuresAction, AppAction {
  const factory MeasuresAction.init(String? userId) = InitMeasuresAction;
  const factory MeasuresAction.update(List<MeasureModel> payload, String? userId) = UpdateMeasureAction;
  const factory MeasuresAction.toggle() = ToggleMeasuresLoading;
}
