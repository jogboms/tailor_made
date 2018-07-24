import 'package:tailor_made/models/settings.dart';
import 'package:tailor_made/redux/actions/main.dart';

class InitSettingsEvents extends ActionType<void> {}

class DisposeSettingsEvents extends ActionType<void> {}

class OnDataSettingEvent extends ActionType<SettingsModel> {
  OnDataSettingEvent({
    SettingsModel payload,
  }) : super(payload: payload);
}
