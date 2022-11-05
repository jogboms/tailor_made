import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'bootstrap.dart';
import 'core.dart';
import 'data.dart';
import 'dependencies.dart';
import 'domain.dart';
import 'presentation.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: const Color(0x00000000),
    ),
  );
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[DeviceOrientation.portraitUp]);

  const Dependencies dependencies = Dependencies();

  final Repository repository;
  switch (environment) {
    case Environment.dev:
    case Environment.prod:
      final Firebase firebase = await Firebase.initialize(options: null);
      repository = FirebaseRepository(
        db: firebase.db,
        auth: firebase.auth,
        storage: firebase.storage,
      );
      break;
    case Environment.testing:
    case Environment.mock:
      repository = MockRepository();
      break;
  }

  runApp(
    App(
      bootstrap: await bootstrap(dependencies, repository, environment),
      store: storeFactory(dependencies, false),
    ),
  );
}

class MockRepository extends Repository {}
