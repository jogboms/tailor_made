import 'package:equatable/equatable.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/measures.dart';

class MeasuresViewModel extends Equatable {
  MeasuresViewModel(AppState state)
      : model = state.measures.measures,
        isLoading = state.measures.status == MeasuresStatus.loading,
        hasError = state.measures.status == MeasuresStatus.failure,
        error = state.measures.error,
        super(<AppState>[state]);

  final dynamic model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;
}
