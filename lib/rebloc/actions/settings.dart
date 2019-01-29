import 'package:rebloc/rebloc.dart';

class SettingsInitAction extends Action {
  const SettingsInitAction();
}

class SettingsUpdateAction extends Action {
  const SettingsUpdateAction(this.settings);

  final dynamic settings;
}
