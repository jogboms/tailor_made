import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/stats.dart';

enum StatsStatus {
  loading,
  success,
  failure,
}

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
        status = StatsStatus.loading,
        message = '',
        error = null;

  final StatsModel stats;
  final StatsStatus status;
  final String message;
  final dynamic error;

  StatsState copyWith({
    StatsModel stats,
    StatsStatus status,
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
  String toString() {
    return '\nStats: $stats';
  }
}
