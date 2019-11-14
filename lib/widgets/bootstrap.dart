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
import 'package:tailor_made/services/session.dart';
import 'package:tailor_made/services/settings/main.dart';
import 'package:tailor_made/services/stats/main.dart';
import 'package:tailor_made/utils/mk_first_time_login_check.dart';

Future<BootstrapModel> bootstrap(Environment env, [bool isTestMode = false]) async {
  final _settings = Session(environment: env, isTestMode: isTestMode);

  Injector.appInstance
    ..registerSingleton<Session>((_) => _settings)
    ..registerSingleton<Accounts>((_) => _settings.isMock ? AccountsMockImpl() : AccountsImpl())
    ..registerSingleton<Contacts>((_) => _settings.isMock ? ContactsMockImpl() : ContactsImpl())
    ..registerSingleton<Jobs>((_) => _settings.isMock ? JobsMockImpl() : JobsImpl())
    ..registerSingleton<Gallery>((_) => _settings.isMock ? GalleryMockImpl() : GalleryImpl())
    ..registerSingleton<Settings>((_) => _settings.isMock ? SettingsMockImpl() : SettingsImpl())
    ..registerSingleton<Payments>((_) => _settings.isMock ? PaymentsMockImpl() : PaymentsImpl())
    ..registerSingleton<Measures>((_) => _settings.isMock ? MeasuresMockImpl() : MeasuresImpl())
    ..registerSingleton<Stats>((_) => _settings.isMock ? StatsMockImpl() : StatsImpl());

  if (_settings.isMock) {
    return BootstrapModel(isFirstTime: true, isTestMode: isTestMode);
  }

  final isFirstTime = await MkFirstTimeLoginCheck.check(_settings.environment);

  return BootstrapModel(isFirstTime: isFirstTime, isTestMode: isTestMode);
}

class BootstrapModel {
  const BootstrapModel({@required this.isFirstTime, this.isTestMode = false});

  final bool isFirstTime;
  final bool isTestMode;
}
