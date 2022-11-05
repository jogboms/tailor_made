import 'package:flutter/material.dart';

@immutable
class CoordinatorBase {
  const CoordinatorBase(this.navigatorKey);

  final GlobalKey<NavigatorState> navigatorKey;

  NavigatorState? get navigator => navigatorKey.currentState;
}
