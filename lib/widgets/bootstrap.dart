import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/services/accounts/main.dart';
import 'package:tailor_made/services/contacts/main.dart';
import 'package:tailor_made/services/gallery/main.dart';
import 'package:tailor_made/services/jobs/main.dart';
import 'package:tailor_made/services/measures/main.dart';
import 'package:tailor_made/services/payments/main.dart';
import 'package:tailor_made/services/settings/main.dart';
import 'package:tailor_made/services/stats/main.dart';
import 'package:tailor_made/utils/mk_settings.dart';

Future<BootstrapModel> bootstrap(Environment env, [bool isTestMode = false]) async {
  MkSettings.environment = env;
  MkSettings.isTestMode = isTestMode;

  Injector.appInstance
    ..registerSingleton<Accounts>((_) => MkSettings.isMock ? AccountsMockImpl() : AccountsImpl())
    ..registerSingleton<Contacts>((_) => MkSettings.isMock ? ContactsMockImpl() : ContactsImpl())
    ..registerSingleton<Jobs>((_) => MkSettings.isMock ? JobsMockImpl() : JobsImpl())
    ..registerSingleton<Gallery>((_) => MkSettings.isMock ? GalleryMockImpl() : GalleryImpl())
    ..registerSingleton<Settings>((_) => MkSettings.isMock ? SettingsMockImpl() : SettingsImpl())
    ..registerSingleton<Payments>((_) => MkSettings.isMock ? PaymentsMockImpl() : PaymentsImpl())
    ..registerSingleton<Measures>((_) => MkSettings.isMock ? MeasuresMockImpl() : MeasuresImpl())
    ..registerSingleton<Stats>((_) => MkSettings.isMock ? StatsMockImpl() : StatsImpl());

  return _BootstrapService.init(isTestMode);
}

class BootstrapModel {
  const BootstrapModel({@required this.isFirstTime, this.isTestMode = false});

  final bool isFirstTime;
  final bool isTestMode;
}

class _BootstrapService {
  static Future<BootstrapModel> init([bool isTestMode = false]) async {
    if (MkSettings.isMock) {
      return BootstrapModel(isFirstTime: true, isTestMode: isTestMode);
    }

    final isFirstTime = await MkSettings.checkIsFirstTimeLogin();

    try {
      await MkSettings.initVersion();
    } catch (e) {
      //
    }

    return BootstrapModel(isFirstTime: isFirstTime, isTestMode: isTestMode);
  }
}
