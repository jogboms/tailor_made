import 'package:flutter/widgets.dart';
import 'package:tailor_made/bootstrap.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/rebloc/store_factory.dart';
import 'package:tailor_made/repository/main.dart';
import 'package:tailor_made/widgets/app.dart';

void main(
  List<String> args,
  Future<Repository> Function() repositoryFactory, {
  Environment environment = Environment.mock,
  int delay = 0,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future<dynamic>.delayed(Duration(seconds: delay));

  const Dependencies dependencies = Dependencies();
  runApp(
    App(
      bootstrap: await bootstrap(dependencies, await repositoryFactory(), environment),
      store: storeFactory(dependencies, false),
    ),
  );
}
