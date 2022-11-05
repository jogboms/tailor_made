import '../models/settings.dart';

abstract class Settings {
  const Settings();

  Stream<SettingsModel?> fetch();
}
