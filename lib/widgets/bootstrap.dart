import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/services/_api/accounts.dart';
import 'package:tailor_made/services/_api/contacts.dart';
import 'package:tailor_made/services/_api/gallery.dart';
import 'package:tailor_made/services/_api/jobs.dart';
import 'package:tailor_made/services/_api/measures.dart';
import 'package:tailor_made/services/_api/payments.dart';
import 'package:tailor_made/services/_api/settings.dart';
import 'package:tailor_made/services/_api/stats.dart';
import 'package:tailor_made/services/_mocks/accounts.dart';
import 'package:tailor_made/services/_mocks/contacts.dart';
import 'package:tailor_made/services/_mocks/gallery.dart';
import 'package:tailor_made/services/_mocks/jobs.dart';
import 'package:tailor_made/services/_mocks/measures.dart';
import 'package:tailor_made/services/_mocks/payments.dart';
import 'package:tailor_made/services/_mocks/settings.dart';
import 'package:tailor_made/services/_mocks/stats.dart';
import 'package:tailor_made/services/accounts.dart';
import 'package:tailor_made/services/contacts.dart';
import 'package:tailor_made/services/gallery.dart';
import 'package:tailor_made/services/jobs.dart';
import 'package:tailor_made/services/measures.dart';
import 'package:tailor_made/services/payments.dart';
import 'package:tailor_made/services/settings.dart';
import 'package:tailor_made/services/stats.dart';
import 'package:tailor_made/utils/mk_settings.dart';

Future<BootstrapModel> bootstrap(Environment env) async {
  MkSettings.environment = env;

  Injector.appInstance
    ..registerSingleton<Accounts>(
      (_) => MkSettings.isMock ? AccountsMockImpl() : AccountsImpl(),
    )
    ..registerSingleton<Contacts>(
      (_) => MkSettings.isMock ? ContactsMockImpl() : ContactsImpl(),
    )
    ..registerSingleton<Jobs>(
      (_) => MkSettings.isMock ? JobsMockImpl() : JobsImpl(),
    )
    ..registerSingleton<Gallery>(
      (_) => MkSettings.isMock ? GalleryMockImpl() : GalleryImpl(),
    )
    ..registerSingleton<Settings>(
      (_) => MkSettings.isMock ? SettingsMockImpl() : SettingsImpl(),
    )
    ..registerSingleton<Payments>(
      (_) => MkSettings.isMock ? PaymentsMockImpl() : PaymentsImpl(),
    )
    ..registerSingleton<Measures>(
      (_) => MkSettings.isMock ? MeasuresMockImpl() : MeasuresImpl(),
    )
    ..registerSingleton<Stats>(
      (_) => MkSettings.isMock ? StatsMockImpl() : StatsImpl(),
    );

  final isFirstTime = await MkSettings.checkIsFirstTimeLogin();

  try {
    await MkSettings.initVersion();
  } catch (e) {
    //
  }

  return BootstrapModel(
    isFirstTime: isFirstTime,
  );
}

class BootstrapModel {
  const BootstrapModel({
    @required this.isFirstTime,
  });

  final bool isFirstTime;
}
