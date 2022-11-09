import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tailor_made/data.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation.dart';
import 'package:tailor_made/presentation/screens/splash/splash.dart';

import 'mocks.dart';
import 'utils.dart';

void main() {
  group('Smoke test', () {
    late NavigatorObserver mockObserver;
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    setUpAll(() {
      registerFallbackValue(FakeRoute());
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('shows and navigates out of SplashPage', (WidgetTester tester) async {
      final Registry registry = createRegistry(
        navigatorKey: navigatorKey,
      );

      when(mockRepositories.accounts.signInWithGoogle).thenAnswer((_) async {});
      when(() => mockRepositories.accounts.onAuthStateChanged).thenAnswer((_) => Stream<User?>.value(const MockUser()));
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
          store: storeFactory(registry),
          navigatorObservers: <NavigatorObserver>[mockObserver],
        ),
      );
      await tester.pump();

      verify(() => mockObserver.didPush(any(), any()));

      expect(find.byType(SplashPage), findsOneWidget);

      await tester.pump();

      verify(() => mockObserver.didPush(any(), any()));
    });
  });
}
