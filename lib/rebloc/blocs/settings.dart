import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/rebloc/actions/settings.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/rebloc/states/settings.dart';

class SettingsBloc extends SimpleBloc<AppState> {
  @override
  AppState reducer(AppState state, Action action) {
    final _settings = state.settings;

    if (action is InitSettingsEvents) {
      return state.copyWith(
        settings: _settings.copyWith(
          status: SettingsStatus.loading,
        ),
      );
    }

    if (action is OnDataSettingEvent) {
      return state.copyWith(
        settings: _settings.copyWith(
          settings: action.payload,
          status: SettingsStatus.success,
        ),
      );
    }

    if (action is OnErrorSettingsEvents) {
      return state.copyWith(
        settings: _settings.copyWith(
          status: SettingsStatus.failure,
        ),
      );
    }

    return state;
  }
}
