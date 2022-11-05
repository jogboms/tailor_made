import 'package:flutter/widgets.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/coordinator/contacts_coordinator.dart';
import 'package:tailor_made/coordinator/gallery_coordinator.dart';
import 'package:tailor_made/coordinator/jobs_coordinator.dart';
import 'package:tailor_made/coordinator/measures_coordinator.dart';
import 'package:tailor_made/coordinator/payments_coordinator.dart';
import 'package:tailor_made/coordinator/shared_coordinator.dart';
import 'package:tailor_made/coordinator/tasks_coordinator.dart';
import 'package:tailor_made/repository/firebase/main.dart';
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

class Dependencies {
  const Dependencies();

  void initialize(Session session, GlobalKey<NavigatorState> navigatorKey, Repository repository) {
    Injector.appInstance
      ..registerSingleton<Dependencies>(() => this)
      ..registerSingleton<Repository>(() => repository)
      ..registerSingleton<Session>(() => session)
      ..registerSingleton<Accounts>(
        () => session.isMock ? AccountsMockImpl() : AccountsImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Contacts>(
        () => session.isMock ? ContactsMockImpl() : ContactsImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Jobs>(() => session.isMock ? JobsMockImpl() : JobsImpl(repository as FirebaseRepository))
      ..registerSingleton<Gallery>(
        () => session.isMock ? GalleryMockImpl() : GalleryImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Settings>(
        () => session.isMock ? SettingsMockImpl() : SettingsImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Payments>(
        () => session.isMock ? PaymentsMockImpl() : PaymentsImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Measures>(
        () => session.isMock ? MeasuresMockImpl() : MeasuresImpl(repository as FirebaseRepository),
      )
      ..registerSingleton<Stats>(() => session.isMock ? StatsMockImpl() : StatsImpl(repository as FirebaseRepository))
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

  Session get session => Injector.appInstance.get<Session>();

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
