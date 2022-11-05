import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'state.freezed.dart';

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
