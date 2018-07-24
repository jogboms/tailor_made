import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/settings.dart';

enum SettingsStatus {
  loading,
  success,
  failure,
}

@immutable
class SettingsState {
  final SettingsModel settings;
  final SettingsStatus status;
  final String message;

  const SettingsState({
    @required this.settings,
    @required this.status,
    @required this.message,
  });

  const SettingsState.initialState()
      : settings = null,
        status = SettingsStatus.loading,
        message = '';

  SettingsState copyWith({
    SettingsModel settings,
    SettingsStatus status,
    String message,
  }) {
    return new SettingsState(
      settings: settings ?? this.settings,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
