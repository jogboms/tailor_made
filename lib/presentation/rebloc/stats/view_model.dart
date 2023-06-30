import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class StatsViewModel extends Equatable {
  StatsViewModel(AppState state)
      : model = state.stats.stats,
        isLoading = state.stats.status == StateStatus.loading,
        hasError = state.stats.status == StateStatus.failure,
        error = state.stats.error;

  final StatsEntity? model;
  final bool isLoading;
  final bool hasError;
  final String? error;

  @override
  List<Object?> get props => <Object?>[model, isLoading, hasError, error];
}
