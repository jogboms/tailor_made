import 'package:flutter/widgets.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/widgets/app.dart';
import 'package:tailor_made/widgets/bootstrap.dart';

void main({Environment environment = Environment.MOCK, int delay = 0}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future<dynamic>.delayed(Duration(seconds: delay));

  runApp(App(bootstrap: await bootstrap(environment)));
}
