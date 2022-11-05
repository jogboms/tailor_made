import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tailor_made/bootstrap.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/rebloc/store_factory.dart';
import 'package:tailor_made/repository/mock/main.dart';
import 'package:tailor_made/screens/splash/splash.dart';
import 'package:tailor_made/widgets/app.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class FakeRoute extends Fake implements Route<void> {}

void main() {
  group('Smoke test', () {
    late NavigatorObserver mockObserver;

    setUpAll(() {
      registerFallbackValue(FakeRoute());
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('shows and navigates out of SplashPage', (WidgetTester tester) async {
      const Dependencies dependencies = Dependencies();
      await tester.pumpWidget(
        App(
          bootstrap: await bootstrap(dependencies, await repositoryFactory(), Environment.mock),
          store: storeFactory(dependencies, true),
          navigatorObservers: <NavigatorObserver>[mockObserver],
        ),
      );

      verify(() => mockObserver.didPush(any(), any()));

      expect(find.byType(SplashPage), findsOneWidget);

      await tester.pump();

      verify(() => mockObserver.didPush(any(), any()));
    });
  });
}
