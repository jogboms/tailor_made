import 'package:flutter/cupertino.dart';
import 'package:mocktail/mocktail.dart' as mt;
import 'package:tailor_made/core.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/coordinator.dart';

import 'mocks.dart';

class MockRepositories {
  final Accounts accounts = MockAccounts();
  final Contacts contacts = MockContacts();
  final Jobs jobs = MockJobs();
  final Gallery gallery = MockGallery();
  final Settings settings = MockSettings();
  final Payments payments = MockPayments();
  final Measures measures = MockMeasures();
  final Stats stats = MockStats();

  void reset() => <Object>[
        accounts,
        contacts,
        jobs,
        gallery,
        settings,
        payments,
        measures,
        stats,
      ].forEach(mt.reset);
}

final MockRepositories mockRepositories = MockRepositories();

Dependencies createRegistry({
  GlobalKey<NavigatorState>? navigatorKey,
  Environment environment = Environment.testing,
}) {
  navigatorKey ??= GlobalKey<NavigatorState>();
  return const Dependencies()
    ..set(mockRepositories.accounts)
    ..set(mockRepositories.contacts)
    ..set(mockRepositories.jobs)
    ..set(mockRepositories.gallery)
    ..set(mockRepositories.settings)
    ..set(mockRepositories.payments)
    ..set(mockRepositories.measures)
    ..set(mockRepositories.stats)
    ..set(environment)
    ..set(ContactsCoordinator(navigatorKey))
    ..set(GalleryCoordinator(navigatorKey))
    ..set(SharedCoordinator(navigatorKey))
    ..set(JobsCoordinator(navigatorKey))
    ..set(MeasuresCoordinator(navigatorKey))
    ..set(PaymentsCoordinator(navigatorKey))
    ..set(TasksCoordinator(navigatorKey))
    ..initialize();
}
