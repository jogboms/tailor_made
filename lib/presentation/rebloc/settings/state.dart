part of 'bloc.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required SettingsModel? settings,
    required StateStatus status,
    required String? error,
  }) = _SettingsState;
}
