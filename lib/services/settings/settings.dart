import 'package:tailor_made/models/settings.dart';

abstract class Settings {
  const Settings();

  Stream<SettingsModel?> fetch();
}
