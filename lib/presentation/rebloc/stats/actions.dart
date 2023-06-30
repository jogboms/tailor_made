part of 'bloc.dart';

@freezed
class StatsAction with _$StatsAction, AppAction {
  const factory StatsAction.init(String userId) = _InitStatsAction;
}
