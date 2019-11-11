import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/app_state.dart';

class MeasuresViewModel extends Equatable {
  MeasuresViewModel(AppState state)
      : model = state.measures.measures,
        grouped = state.measures.grouped,
        isLoading = state.measures.status == StateStatus.loading,
        hasError = state.measures.status == StateStatus.failure,
        error = state.measures.error,
        super(<AppState>[state]);

  final Map<String, List<MeasureModel>> grouped;
  final List<MeasureModel> model;
  final bool isLoading;
  final bool hasError;
  final dynamic error;
}
