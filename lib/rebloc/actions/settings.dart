import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/settings.dart';

class InitSettingsEvents extends Action {
  const InitSettingsEvents();
}

class DisposeSettingsEvents extends Action {
  const DisposeSettingsEvents();
}

class OnErrorSettingsEvents extends Action {
  const OnErrorSettingsEvents();
}

class OnDataSettingEvent extends Action {
  const OnDataSettingEvent({
    @required this.payload,
  });

  final SettingsModel payload;
}
