import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/rebloc/app_state.dart';

class StatsViewModel extends Equatable {
  StatsViewModel(AppState state)
      : model = state.stats.stats,
        isLoading = state.stats.status == StateStatus.loading,
        hasError = state.stats.status == StateStatus.failure,
        error = state.stats.error,
        super(<AppState>[state]);

  final StatsModel model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;
}
