part of 'bloc.dart';

@freezed
class MeasuresState with _$MeasuresState {
  const factory MeasuresState({
    required List<MeasureEntity>? measures,
    required Map<MeasureGroup, List<MeasureEntity>>? grouped,
    required bool hasSkippedPremium,
    required StateStatus status,
    required String? error,
  }) = _MeasuresState;
}
