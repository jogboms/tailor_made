part of 'bloc.dart';

@freezed
class MeasuresState with _$MeasuresState {
  const factory MeasuresState({
    required List<MeasureModel>? measures,
    required Map<String, List<MeasureModel>>? grouped,
    required bool hasSkipedPremium,
    required StateStatus status,
    required String? error,
  }) = _MeasuresState;
}
