import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/settings.dart';

class InitSettingsEvents extends Action {
  const InitSettingsEvents();
}

class OnErrorSettingsEvents extends Action {
  const OnErrorSettingsEvents();
}

class OnDataSettingAction extends Action {
  const OnDataSettingAction({
    @required this.payload,
  });

  final SettingsModel payload;
}
