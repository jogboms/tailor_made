import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';

import 'core.dart';
import 'data.dart';
import 'domain.dart';
import 'presentation.dart';

class Dependencies {
  const Dependencies();

  void initialize(Environment env, GlobalKey<NavigatorState> navigatorKey, Repository repository) {
    Injector.appInstance
      ..registerSingleton<Dependencies>(() => this)
      ..registerSingleton<Repository>(() => repository)
      ..registerSingleton<Environment>(() => env)
      ..registerSingleton<Accounts>(
        () => env.isMock ? AccountsMockImpl() : AccountsImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Contacts>(
        () => env.isMock ? ContactsMockImpl() : ContactsImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Jobs>(() => env.isMock ? JobsMockImpl() : JobsImpl(repository as FirebaseRepository))
      ..registerSingleton<Gallery>(
        () => env.isMock ? GalleryMockImpl() : GalleryImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Settings>(
        () => env.isMock ? SettingsMockImpl() : SettingsImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Payments>(
        () => env.isMock ? PaymentsMockImpl() : PaymentsImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Measures>(
        () => env.isMock ? MeasuresMockImpl() : MeasuresImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Stats>(() => env.isMock ? StatsMockImpl() : StatsImpl(repository as FirebaseRepository))
      ..registerSingleton<ContactsCoordinator>(() => ContactsCoordinator(navigatorKey))
      ..registerSingleton<GalleryCoordinator>(() => GalleryCoordinator(navigatorKey))
      ..registerSingleton<SharedCoordinator>(() => SharedCoordinator(navigatorKey))
      ..registerSingleton<JobsCoordinator>(() => JobsCoordinator(navigatorKey))
      ..registerSingleton<MeasuresCoordinator>(() => MeasuresCoordinator(navigatorKey))
      ..registerSingleton<PaymentsCoordinator>(() => PaymentsCoordinator(navigatorKey))
      ..registerSingleton<TasksCoordinator>(() => TasksCoordinator(navigatorKey));
  }

  @visibleForTesting
  void dispose() {
    Injector.appInstance.clearAll();
  }

  static Dependencies di() => Injector.appInstance.get<Dependencies>();

  Repository get repository => Injector.appInstance.get<Repository>();

  Environment get environment => Injector.appInstance.get<Environment>();

  Accounts get accounts => Injector.appInstance.get<Accounts>();

  Contacts get contacts => Injector.appInstance.get<Contacts>();

  Jobs get jobs => Injector.appInstance.get<Jobs>();

  Gallery get gallery => Injector.appInstance.get<Gallery>();

  Settings get settings => Injector.appInstance.get<Settings>();

  Payments get payments => Injector.appInstance.get<Payments>();

  Measures get measures => Injector.appInstance.get<Measures>();

  Stats get stats => Injector.appInstance.get<Stats>();

  ContactsCoordinator get contactsCoordinator => Injector.appInstance.get<ContactsCoordinator>();

  GalleryCoordinator get galleryCoordinator => Injector.appInstance.get<GalleryCoordinator>();

  SharedCoordinator get sharedCoordinator => Injector.appInstance.get<SharedCoordinator>();

  JobsCoordinator get jobsCoordinator => Injector.appInstance.get<JobsCoordinator>();

  MeasuresCoordinator get measuresCoordinator => Injector.appInstance.get<MeasuresCoordinator>();

  PaymentsCoordinator get paymentsCoordinator => Injector.appInstance.get<PaymentsCoordinator>();

  TasksCoordinator get tasksCoordinator => Injector.appInstance.get<TasksCoordinator>();
}
