import 'package:flutter/material.dart';

@immutable
class CoordinatorBase {
  const CoordinatorBase(this.navigatorKey) : assert(navigatorKey != null);

  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorState get navigator => navigatorKey?.currentState;
}
