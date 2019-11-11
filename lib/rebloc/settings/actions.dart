import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/settings.dart';

class InitSettingsAction extends Action {
  const InitSettingsAction();
}

class OnErrorSettingsAction extends Action {
  const OnErrorSettingsAction();
}

class OnDataSettingAction extends Action {
  const OnDataSettingAction({@required this.payload});

  final SettingsModel payload;
}
