import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/rebloc/app_state.dart';

@immutable
class SettingsState {
  const SettingsState({
    @required this.settings,
    @required this.status,
    @required this.message,
    this.error,
  });

  const SettingsState.initialState()
      : settings = null,
        status = StateStatus.loading,
        message = '',
        error = null;

  final SettingsModel settings;
  final StateStatus status;
  final String message;
  final dynamic error;

  SettingsState copyWith({
    SettingsModel settings,
    StateStatus status,
    String message,
    dynamic error,
  }) {
    return SettingsState(
      settings: settings ?? this.settings,
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => """
Settings: $settings
    """;
}
