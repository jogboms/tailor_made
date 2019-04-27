import 'package:injector/injector.dart';
import 'package:tailor_made/models/settings.dart';

abstract class Settings {
  static Settings di() {
    return Injector.appInstance.getDependency<Settings>();
  }

  Stream<SettingsModel> fetch();
}
