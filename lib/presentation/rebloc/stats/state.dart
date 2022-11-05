import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'state.freezed.dart';

@freezed
class StatsState with _$StatsState {
  const factory StatsState({
    required StatsModel? stats,
    required StateStatus status,
    required String? error,
  }) = _StatsState;
}
