import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:registry/registry.dart';
import 'package:tailor_made/data.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/screens/homepage/homepage.dart';
import 'package:tailor_made/presentation/screens/splash/splash.dart';

import '../mocks.dart';
import '../utils.dart';

void main() {
  group('App', () {
    setUpAll(() {
      registerFallbackValue(FakeRoute());
    });

    testWidgets('shows SplashPage and navigates HomePage', (WidgetTester tester) async {
      final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
      final NavigatorObserver mockObserver = MockNavigatorObserver();
      final Registry registry = createRegistry(
        navigatorKey: navigatorKey,
      );

      when(mockRepositories.accounts.signInWithGoogle).thenAnswer((_) async {});
      when(() => mockRepositories.accounts.onAuthStateChanged).thenAnswer((_) => Stream<String?>.value('1'));
      when(() => mockRepositories.accounts.getAccount(any())).thenAnswer((_) => AccountsMockImpl().getAccount('1'));
      when(mockRepositories.settings.fetch).thenAnswer((_) => SettingsMockImpl().fetch());
      when(() => mockRepositories.measures.fetchAll(any())).thenAnswer((_) => MeasuresMockImpl().fetchAll('1'));
      when(() => mockRepositories.jobs.fetchAll(any())).thenAnswer((_) => JobsMockImpl().fetchAll('1'));
      when(() => mockRepositories.contacts.fetchAll(any())).thenAnswer((_) => ContactsMockImpl().fetchAll('1'));
      when(() => mockRepositories.stats.fetch(any())).thenAnswer((_) => StatsMockImpl().fetch('1'));

      await tester.pumpWidget(
        App(
          registry: registry,
          navigatorKey: navigatorKey,
          navigatorObservers: <NavigatorObserver>[mockObserver],
        ),
      );
      await tester.pump();

      expect(find.byType(SplashPage), findsOneWidget);

      await tester.pump();

      await tester.verifyPushNavigation<HomePage>(mockObserver);
    });
  });
}
