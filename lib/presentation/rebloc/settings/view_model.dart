import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class SettingsViewModel extends Equatable {
  SettingsViewModel(AppState state)
      : model = state.settings.settings,
        isLoading = state.settings.status == StateStatus.loading,
        hasError = state.settings.status == StateStatus.failure,
        error = state.settings.error;

  final SettingEntity? model;
  final bool isLoading;
  final bool hasError;
  final String? error;

  @override
  List<Object?> get props => <Object?>[model, isLoading, hasError, error];
}
