import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/measure.dart';

enum MeasuresStatus {
  loading,
  success,
  failure,
}

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
        status = MeasuresStatus.loading,
        hasSkipedPremium = false,
        message = '',
        error = null;

  final List<MeasureModel> measures;
  final Map<String, List<MeasureModel>> grouped;
  final MeasuresStatus status;
  final bool hasSkipedPremium;
  final String message;
  final dynamic error;

  MeasuresState copyWith({
    List<MeasureModel> measures,
    Map<String, List<MeasureModel>> grouped,
    MeasuresStatus status,
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
  String toString() {
    return '\nMeasures: $measures, \nGrouped: $grouped, \nHasSkipedPremium: $hasSkipedPremium';
  }
}
