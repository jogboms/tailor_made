import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MkNavigate {
  static PageRoute<T> slideIn<T extends Object>(Widget widget, {String name, bool fullscreenDialog = false}) {
    return CupertinoPageRoute<T>(
      builder: (_) => widget,
      settings: name != null ? RouteSettings(name: name) : null,
      maintainState: true,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static PageRoute<T> fadeIn<T extends Object>(Widget widget, {String name}) {
    return PageRouteBuilder<T>(
      opaque: false,
      pageBuilder: (_, __, ___) => widget,
      transitionsBuilder: (_, animation, __, child) => FadeTransition(opacity: animation, child: child),
      settings: name != null ? RouteSettings(name: name) : null,
      maintainState: true,
    );
  }
}
