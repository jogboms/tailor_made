import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/rebloc/store_factory.dart';
import 'package:tailor_made/repository/mock/main.dart';
import 'package:tailor_made/screens/splash/splash.dart';
import 'package:tailor_made/services/session.dart';
import 'package:tailor_made/widgets/app.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group("Smoke test", () {
    NavigatorObserver mockObserver;

    setUpAll(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('shows and navigates out of SplashPage', (WidgetTester tester) async {
      const dependencies = Dependencies();
      final session = Session(environment: Environment.MOCK);
      final navigatorKey = GlobalKey<NavigatorState>();
      dependencies.initialize(session, navigatorKey, repositoryFactory());

      await tester.pumpWidget(App(
        version: "1.0.0",
        navigatorKey: navigatorKey,
        store: storeFactory(dependencies, true),
        navigatorObservers: [mockObserver],
      ));

      verify(mockObserver.didPush(any, any));

      expect(find.byType(SplashPage), findsOneWidget);

      await tester.pump();

      verify(mockObserver.didPush(any, any));
    });
  });
}
