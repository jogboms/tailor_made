import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/actions/settings.dart';
import 'package:tailor_made/redux/states/settings.dart';

SettingsState reducer(SettingsState settings, ActionType action) {
  if (action is OnDataSettingEvent) {
    return settings.copyWith(
      settings: action.payload,
      status: SettingsStatus.success,
    );
  }

  return settings;
}
