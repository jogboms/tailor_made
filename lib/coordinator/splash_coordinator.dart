import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/coordinator/coordinator_base.dart';

@immutable
class SplashCoordinator extends CoordinatorBase {
  const SplashCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  static SplashCoordinator di() => Injector.appInstance.getDependency<SplashCoordinator>();
}
