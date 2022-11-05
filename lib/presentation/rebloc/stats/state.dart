part of 'bloc.dart';

@freezed
class StatsState with _$StatsState {
  const factory StatsState({
    required StatsModel? stats,
    required StateStatus status,
    required String? error,
  }) = _StatsState;
}
