import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'app_state.freezed.dart';

@freezed
class AppState with _$AppState {
  const factory AppState({
    required MeasuresState measures,
  }) = _AppState;

  static const AppState initialState = AppState(
    measures: MeasuresState(
      measures: null,
      grouped: null,
      status: StateStatus.loading,
      hasSkippedPremium: false,
      error: null,
    ),
  );
}
