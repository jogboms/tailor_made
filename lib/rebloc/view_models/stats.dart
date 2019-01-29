import 'package:equatable/equatable.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/stats.dart';

class StatsViewModel extends Equatable {
  StatsViewModel(AppState state)
      : model = state.stats.stats,
        isLoading = state.stats.status == StatsStatus.loading,
        hasError = state.stats.status == StatsStatus.failure,
        error = state.stats.error,
        super(<AppState>[state]);

  final dynamic model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;
}
