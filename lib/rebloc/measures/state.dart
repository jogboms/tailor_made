import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/app_state.dart';

@immutable
class MeasuresState {
  const MeasuresState({
    @required this.measures,
    @required this.grouped,
    @required this.status,
    @required this.hasSkipedPremium,
    @required this.message,
    this.error,
  });

  const MeasuresState.initialState()
      : measures = null,
        grouped = null,
        status = StateStatus.loading,
        hasSkipedPremium = false,
        message = '',
        error = null;

  final List<MeasureModel> measures;
  final Map<String, List<MeasureModel>> grouped;
  final StateStatus status;
  final bool hasSkipedPremium;
  final String message;
  final dynamic error;

  MeasuresState copyWith({
    List<MeasureModel> measures,
    Map<String, List<MeasureModel>> grouped,
    StateStatus status,
    bool hasSkipedPremium,
    String message,
    dynamic error,
  }) {
    return MeasuresState(
      measures: measures ?? this.measures,
      grouped: grouped ?? this.grouped,
      status: status ?? this.status,
      hasSkipedPremium: hasSkipedPremium ?? this.hasSkipedPremium,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => """
Measures: $measures,
Grouped: $grouped,
HasSkipedPremium: $hasSkipedPremium
    """;
}
