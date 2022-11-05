import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/domain.dart';

Future<BootstrapModel> bootstrap(Dependencies dependencies, Repository repository, Environment env) async {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  dependencies.initialize(env, navigatorKey, repository);

  if (env.isMock) {
    return BootstrapModel(navigatorKey: navigatorKey, isFirstTime: true, isMock: true);
  }

  final bool isFirstTime = await FirstTimeLoginCheck.check(env);
  return BootstrapModel(navigatorKey: navigatorKey, isFirstTime: isFirstTime, isMock: false);
}

class BootstrapModel {
  const BootstrapModel({required this.navigatorKey, required this.isFirstTime, required this.isMock});

  final GlobalKey<NavigatorState> navigatorKey;
  final bool isFirstTime;
  final bool isMock;
}
