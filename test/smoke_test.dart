import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_made/bootstrap.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/repository/mock/main.dart';
import 'package:tailor_made/screens/splash/splash.dart';
import 'package:tailor_made/widgets/app.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    final BootstrapModel bs = await bootstrap(repositoryFactory(), Environment.MOCK, true);

    // Build our app and trigger a frame.
    await tester.pumpWidget(App(bootstrap: bs));

    expect(find.byType(SplashPage), findsOneWidget);
  });
}
