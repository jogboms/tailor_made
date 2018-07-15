import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/stats.dart';

enum StatsStatus {
  loading,
  success,
  failure,
}

@immutable
class StatsState {
  final StatsModel stats;
  final StatsStatus status;
  final String message;

  StatsState({this.stats, this.status, this.message});

  StatsState copyWith({
    StatsModel stats,
    StatsStatus status,
    String message,
  }) {
    return new StatsState(
      stats: stats ?? this.stats,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  StatsState.initialState()
      : stats = null,
        status = StatsStatus.loading,
        message = "";
}
