import 'package:flutter/foundation.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/models/settings.dart';

class Session {
  Session({@required this.environment, @required this.isTestMode});

  static Session di() => Injector.appInstance.getDependency<Session>();

  final Environment environment;

  final bool isTestMode;

  bool get isDev => environment == Environment.DEVELOPMENT;

  bool get isMock => environment == Environment.MOCK;

  bool get isTesting => isTestMode;

  String _userId;

  void setUserId(String id) => _userId = id;

  String getUserId() => _userId;

  SettingsModel _settings;

  void setSettings(SettingsModel data) => _settings = data;

  SettingsModel getSettings() => _settings;
}
