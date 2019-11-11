import 'package:flutter/foundation.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/models/settings.dart';

class MkSettings {
  MkSettings({@required this.environment, @required this.isTestMode});

  static MkSettings di() => Injector.appInstance.getDependency<MkSettings>();

  final Environment environment;
  final bool isTestMode;

  SettingsModel _settings;
  int _userId;

  bool get isDev => environment == Environment.DEVELOPMENT;

  bool get isMock => environment == Environment.MOCK;

  bool get isTesting => isTestMode;

  void setUserId(int id) => _userId = id;

  int getUserId() => _userId;

  void setData(SettingsModel data) => _settings = data;

  SettingsModel getData() => _settings;
}
