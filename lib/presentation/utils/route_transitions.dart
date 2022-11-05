import 'package:flutter/cupertino.dart';

class RouteTransitions {
  static PageRoute<T> slideIn<T extends Object>(
    Widget widget, {
    String? name,
    RouteSettings? settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    PageRoute<Object>? hostRoute,
  }) {
    return CupertinoPageRoute<T>(
      builder: (BuildContext context) => widget,
      settings: name != null ? RouteSettings(name: name) : settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static PageRoute<T> fadeIn<T extends Object>(
    Widget widget, {
    String? name,
    RouteSettings? settings,
    bool maintainState = true,
  }) {
    return PageRouteBuilder<T>(
      opaque: false,
      pageBuilder: (_, __, ___) => widget,
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) =>
          FadeTransition(opacity: animation, child: child),
      settings: name != null ? RouteSettings(name: name) : settings,
      maintainState: maintainState,
    );
  }
}
