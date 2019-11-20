import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tailor_made/bootstrap.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/rebloc/store_factory.dart';
import 'package:tailor_made/repository/mock/main.dart';
import 'package:tailor_made/screens/splash/splash.dart';
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
      await tester.pumpWidget(App(
        bootstrap: await bootstrap(dependencies, repositoryFactory(), Environment.MOCK),
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
