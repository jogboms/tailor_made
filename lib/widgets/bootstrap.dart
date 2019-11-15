import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/coordinator/contacts_coordinator.dart';
import 'package:tailor_made/coordinator/gallery_coordinator.dart';
import 'package:tailor_made/coordinator/jobs_coordinator.dart';
import 'package:tailor_made/coordinator/measures_coordinator.dart';
import 'package:tailor_made/coordinator/payments_coordinator.dart';
import 'package:tailor_made/coordinator/shared_coordinator.dart';
import 'package:tailor_made/coordinator/splash_coordinator.dart';
import 'package:tailor_made/coordinator/tasks_coordinator.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/repository/main.dart';
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

Future<BootstrapModel> bootstrap(Repository repository, Environment env, [bool isTestMode = false]) async {
  final _settings = Session(environment: env, isTestMode: isTestMode);
  final _navigatorKey = GlobalKey<NavigatorState>();

  Injector.appInstance
    ..registerSingleton<Repository>((_) => repository)
    ..registerSingleton<Session>((_) => _settings)
    ..registerSingleton<Accounts>((_) => _settings.isMock ? AccountsMockImpl() : AccountsImpl())
    ..registerSingleton<Contacts>((_) => _settings.isMock ? ContactsMockImpl() : ContactsImpl())
    ..registerSingleton<Jobs>((_) => _settings.isMock ? JobsMockImpl() : JobsImpl())
    ..registerSingleton<Gallery>((_) => _settings.isMock ? GalleryMockImpl() : GalleryImpl())
    ..registerSingleton<Settings>((_) => _settings.isMock ? SettingsMockImpl() : SettingsImpl())
    ..registerSingleton<Payments>((_) => _settings.isMock ? PaymentsMockImpl() : PaymentsImpl())
    ..registerSingleton<Measures>((_) => _settings.isMock ? MeasuresMockImpl() : MeasuresImpl())
    ..registerSingleton<Stats>((_) => _settings.isMock ? StatsMockImpl() : StatsImpl())
    ..registerSingleton<ContactsCoordinator>((_) => ContactsCoordinator(_navigatorKey))
    ..registerSingleton<GalleryCoordinator>((_) => GalleryCoordinator(_navigatorKey))
    ..registerSingleton<SharedCoordinator>((_) => SharedCoordinator(_navigatorKey))
    ..registerSingleton<JobsCoordinator>((_) => JobsCoordinator(_navigatorKey))
    ..registerSingleton<MeasuresCoordinator>((_) => MeasuresCoordinator(_navigatorKey))
    ..registerSingleton<PaymentsCoordinator>((_) => PaymentsCoordinator(_navigatorKey))
    ..registerSingleton<SplashCoordinator>((_) => SplashCoordinator(_navigatorKey))
    ..registerSingleton<TasksCoordinator>((_) => TasksCoordinator(_navigatorKey));

  if (_settings.isMock) {
    return BootstrapModel(navigatorKey: _navigatorKey, isFirstTime: true, isTestMode: isTestMode);
  }

  final isFirstTime = await MkFirstTimeLoginCheck.check(_settings.environment);
  return BootstrapModel(navigatorKey: _navigatorKey, isFirstTime: isFirstTime, isTestMode: isTestMode);
}

class BootstrapModel {
  const BootstrapModel({@required this.navigatorKey, @required this.isFirstTime, this.isTestMode = false});

  final GlobalKey<NavigatorState> navigatorKey;
  final bool isFirstTime;
  final bool isTestMode;
}
