part of 'bloc.dart';

@freezed
class SettingsAction with _$SettingsAction, AppAction {
  const factory SettingsAction.init() = _InitSettingsAction;
  const factory SettingsAction.error() = _OnErrorSettingsAction;
}
