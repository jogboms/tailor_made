import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/rebloc/app_state.dart';

@immutable
class StatsState {
  const StatsState({
    @required this.stats,
    @required this.status,
    @required this.message,
    this.error,
  });

  const StatsState.initialState()
      : stats = null,
        status = StateStatus.loading,
        message = '',
        error = null;

  final StatsModel stats;
  final StateStatus status;
  final String message;
  final dynamic error;

  StatsState copyWith({
    StatsModel stats,
    StateStatus status,
    String message,
    dynamic error,
  }) {
    return StatsState(
      stats: stats ?? this.stats,
      status: status ?? this.status,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => """
Stats: $stats
    """;
}
