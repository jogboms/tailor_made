import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MkNavigate {
  static PageRoute<T> slideIn<T extends Object>(
    Widget widget, {
    String name,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    PageRoute hostRoute,
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
    String name,
    RouteSettings settings,
    bool maintainState = true,
  }) {
    return PageRouteBuilder<T>(
      opaque: false,
      pageBuilder: (_, __, ___) => widget,
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
      settings: name != null ? RouteSettings(name: name) : settings,
      maintainState: maintainState,
    );
  }
}
