import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as mt;
import 'package:registry/registry.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';

import 'mocks.dart';

class MockRepositories {
  final Accounts accounts = MockAccounts();
  final Contacts contacts = MockContacts();
  final Jobs jobs = MockJobs();
  final Gallery gallery = MockGallery();
  final ImageStorage imageStorage = MockImageStorage();
  final Settings settings = MockSettings();
  final Payments payments = MockPayments();
  final Measures measures = MockMeasures();
  final Stats stats = MockStats();

  void reset() => <Object>[
        accounts,
        contacts,
        jobs,
        gallery,
        imageStorage,
        settings,
        payments,
        measures,
        stats,
      ].forEach(mt.reset);
}

final MockRepositories mockRepositories = MockRepositories();

Registry createRegistry({
  GlobalKey<NavigatorState>? navigatorKey,
  Environment environment = Environment.testing,
}) {
  navigatorKey ??= GlobalKey<NavigatorState>();
  return Registry()
    ..set(mockRepositories.accounts)
    ..set(mockRepositories.contacts)
    ..set(mockRepositories.jobs)
    ..set(mockRepositories.gallery)
    ..set(mockRepositories.imageStorage)
    ..set(mockRepositories.settings)
    ..set(mockRepositories.payments)
    ..set(mockRepositories.measures)
    ..set(mockRepositories.stats)
    ..set(environment)
    ..factory((RegistryFactory di) => FetchAccountUseCase(accounts: di()))
    ..factory((RegistryFactory di) => SignInUseCase(accounts: di()))
    ..factory((RegistryFactory di) => SignOutUseCase(accounts: di()))
    ..set(ContactsCoordinator(navigatorKey))
    ..set(GalleryCoordinator(navigatorKey))
    ..set(SharedCoordinator(navigatorKey))
    ..set(JobsCoordinator(navigatorKey))
    ..set(MeasuresCoordinator(navigatorKey))
    ..set(PaymentsCoordinator(navigatorKey))
    ..set(TasksCoordinator(navigatorKey));
}

Widget createApp({
  Widget? home,
  Registry? registry,
  List<Override>? overrides,
  List<NavigatorObserver>? observers,
  GlobalKey<NavigatorState>? navigatorKey,
  bool includeMaterial = true,
}) {
  registry ??= createRegistry();
  navigatorKey ??= GlobalKey<NavigatorState>();

  return ProviderScope(
    overrides: <Override>[
      registryProvider.overrideWithValue(registry),
      ...?overrides,
    ],
    child: App(
      registry: registry,
      navigatorKey: navigatorKey,
      navigatorObservers: observers,
      home: includeMaterial ? Material(child: home) : home,
    ),
  );
}

extension WidgetTesterExtensions on WidgetTester {
  Future<void> verifyPushNavigation<U extends Widget>(NavigatorObserver observer) async {
    // NOTE: This is done for pages that show any indefinite animated loaders, CircularProgress
    await pump();
    await pump();

    mt.verify(() => observer.didPush(mt.any(), mt.any()));
    expect(find.byType(U), findsOneWidget);
  }

  Future<void> verifyPopNavigation(NavigatorObserver observer) async {
    // NOTE: This is done for pages that show any indefinite animated loaders, CircularProgress
    await pump();
    await pump();

    mt.verify(() => observer.didPop(mt.any(), mt.any()));
  }
}
