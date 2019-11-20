import 'package:flutter/widgets.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/rebloc/store_factory.dart';
import 'package:tailor_made/repository/main.dart';
import 'package:tailor_made/services/session.dart';
import 'package:tailor_made/widgets/app.dart';

void main(
  Repository Function() repositoryFactory, {
  Environment environment = Environment.MOCK,
  int delay = 0,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future<dynamic>.delayed(Duration(seconds: delay));

  const dependencies = Dependencies();
  final session = Session(environment: environment);
  final navigatorKey = GlobalKey<NavigatorState>();
  final repository = repositoryFactory();
  dependencies.initialize(session, navigatorKey, repository);

  runApp(App(
    navigatorKey: navigatorKey,
    isMock: session.isMock,
    store: storeFactory(dependencies, false),
  ));
}
