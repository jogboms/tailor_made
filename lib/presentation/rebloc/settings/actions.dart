part of 'bloc.dart';

@freezed
class SettingsAction with _$SettingsAction, AppAction {
  const factory SettingsAction.init() = InitSettingsAction;
  const factory SettingsAction.error() = OnErrorSettingsAction;
}
