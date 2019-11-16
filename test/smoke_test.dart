import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/widgets/app.dart';
import 'package:tailor_made/bootstrap.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    final BootstrapModel bs = await bootstrap(factory(), Environment.MOCK, true);

    // Build our app and trigger a frame.
    await tester.pumpWidget(App(bootstrap: bs));

    expect(find.byType(App), findsOneWidget);
  });
}
