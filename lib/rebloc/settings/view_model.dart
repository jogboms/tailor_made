import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/rebloc/app_state.dart';

class SettingsViewModel extends Equatable {
  SettingsViewModel(AppState state)
      : model = state.settings.settings,
        isLoading = state.settings.status == StateStatus.loading,
        hasError = state.settings.status == StateStatus.failure,
        error = state.settings.error,
        super(<AppState>[state]);

  final SettingsModel model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;
}
