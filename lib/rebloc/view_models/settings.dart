import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/settings.dart';

class SettingsViewModel extends Equatable {
  SettingsViewModel(AppState state)
      : model = state.settings.settings,
        isLoading = state.settings.status == SettingsStatus.loading,
        hasError = state.settings.status == SettingsStatus.failure,
        error = state.settings.error,
        super(<AppState>[state]);

  final SettingsModel model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;
}
