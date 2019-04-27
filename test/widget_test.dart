// This is a basic Flutter widget test.
// To perform an interaction with a widget in your test, use the WidgetTester utility that Flutter
// provides. For example, you can send tap and scroll gestures. You can also use WidgetTester to
// find child widgets in the widget tree, read text, and verify that the values of widget properties
// are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/widgets/app.dart';
import 'package:tailor_made/widgets/bootstrap.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    tester.binding.addTime(Duration(seconds: 3));

    final BootstrapModel bs = await bootstrap(Environment.MOCK);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      App(bootstrap: bs),
    );

    await tester.pumpAndSettle();

    expect(find.byType(App), findsOneWidget);
  });
}
