import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'bootstrap.dart';
import 'core.dart';
import 'dependencies.dart';
import 'domain.dart';
import 'presentation.dart';

void main(
  List<String> args,
  Future<Repository> Function() repositoryFactory, {
  Environment environment = Environment.mock,
  int delay = 0,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future<dynamic>.delayed(Duration(seconds: delay));

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);

  const Dependencies dependencies = Dependencies();
  runApp(
    App(
      bootstrap: await bootstrap(dependencies, await repositoryFactory(), environment),
      store: storeFactory(dependencies, false),
    ),
  );
}
