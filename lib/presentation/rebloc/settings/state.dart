import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'state.freezed.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    required SettingsModel? settings,
    required StateStatus status,
    required String? error,
  }) = _SettingsState;
}
