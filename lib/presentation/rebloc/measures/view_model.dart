import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class MeasuresViewModel extends Equatable {
  MeasuresViewModel(AppState state)
      : _model = state.measures.measures,
        grouped = state.measures.grouped,
        userId = state.account.account!.uid,
        isLoading = state.measures.status == StateStatus.loading,
        hasError = state.measures.status == StateStatus.failure,
        error = state.measures.error;

  final Map<String, List<MeasureModel>>? grouped;

  final List<MeasureModel>? _model;

  List<MeasureModel>? get model => _model;

  final String userId;
  final bool isLoading;
  final bool hasError;
  final dynamic error;

  @override
  List<Object?> get props => <Object?>[model, userId, isLoading, hasError, error];
}
