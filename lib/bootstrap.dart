import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/repository/main.dart';
import 'package:tailor_made/services/session.dart';
import 'package:tailor_made/utils/mk_first_time_login_check.dart';

Future<BootstrapModel> bootstrap(Dependencies dependencies, Repository repository, Environment env) async {
  final Session session = Session(environment: env);
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  dependencies.initialize(session, navigatorKey, repository);

  if (session.isMock) {
    return BootstrapModel(navigatorKey: navigatorKey, isFirstTime: true, isMock: true);
  }

  final bool isFirstTime = await MkFirstTimeLoginCheck.check(env);
  return BootstrapModel(navigatorKey: navigatorKey, isFirstTime: isFirstTime, isMock: false);
}

class BootstrapModel {
  const BootstrapModel({required this.navigatorKey, required this.isFirstTime, required this.isMock});

  final GlobalKey<NavigatorState> navigatorKey;
  final bool isFirstTime;
  final bool isMock;
}
