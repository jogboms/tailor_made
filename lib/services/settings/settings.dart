import 'package:tailor_made/models/settings.dart';

abstract class Settings {
  Stream<SettingsModel> fetch();
}
