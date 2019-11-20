import 'package:flutter/widgets.dart';
import 'package:tailor_made/bootstrap.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/rebloc/store_factory.dart';
import 'package:tailor_made/repository/main.dart';
import 'package:tailor_made/widgets/app.dart';

void main(
  Repository Function() repositoryFactory, {
  Environment environment = Environment.MOCK,
  int delay = 0,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future<dynamic>.delayed(Duration(seconds: delay));

  const dependencies = Dependencies();
  runApp(App(
    bootstrap: await bootstrap(dependencies, repositoryFactory(), environment),
    store: storeFactory(dependencies, false),
  ));
}
