import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MkPageRoute {
  static CupertinoPageRoute slideIn<T>(
    Widget widget, {
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) {
    return CupertinoPageRoute<T>(
      builder: (BuildContext context) => widget,
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static Route<T> fadeIn<T>(
    Widget widget, {
    RouteSettings settings,
    bool maintainState = true,
  }) {
    return PageRouteBuilder<T>(
      opaque: false,
      pageBuilder: (_, __, ___) => widget,
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return FadeTransition(opacity: animation, child: child);
      },
      settings: settings,
      maintainState: maintainState,
    );
  }

  static Route<T> slideUp<T>(
    Widget widget, {
    RouteSettings settings,
    bool maintainState = true,
  }) {
    return MaterialPageRoute<T>(
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: true,
      builder: (BuildContext context) => widget,
    );
  }
}

class MkNavigate {
  MkNavigate(
    BuildContext context,
    Widget widget, {
    String name,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    PageRoute hostRoute,
  }) {
    Navigator.push<dynamic>(
      context,
      MkNavigate.slideIn<dynamic>(
        widget,
        name: name,
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        hostRoute: hostRoute,
      ),
    );
  }

  static CupertinoPageRoute slideIn<T>(
    Widget widget, {
    String name,
    RouteSettings settings,
    bool maintainState = true,
    bool fullscreenDialog = false,
    PageRoute hostRoute,
  }) {
    final _settings = name != null ? RouteSettings(name: name) : settings;
    return MkPageRoute.slideIn<T>(
      widget,
      settings: _settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static Route<T> fadeIn<T>(
    Widget widget, {
    String name,
    RouteSettings settings,
    bool maintainState = true,
  }) {
    final _settings = name != null ? RouteSettings(name: name) : settings;
    return MkPageRoute.fadeIn<T>(
      widget,
      settings: _settings,
      maintainState: maintainState,
    );
  }

  static Route<T> slideUp<T>(
    Widget widget, {
    String name,
    RouteSettings settings,
    bool maintainState = true,
  }) {
    final _settings = name != null ? RouteSettings(name: name) : settings;
    return MkPageRoute.slideUp<T>(
      widget,
      settings: _settings,
      maintainState: maintainState,
    );
  }
}

class MkNavigateRoute<T> extends MaterialPageRoute<T> {
  MkNavigateRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> positionIn(Animation<double> animation) => Tween<Offset>(
          // begin: const Offset(1.0, 0.0),
          // begin: const Offset(0.0, 1.0),
          begin: const Offset(0.0, 0.3),
          end: Offset.zero,
        ).animate(animation);

    // Animation<Offset> positionOut(Animation<double> animation) => Tween<Offset>(
    //       begin: Offset.zero,
    //       end: Offset.zero,
    //     ).animate(animation);

    if (settings.isInitialRoute) {
      return child;
    }
    // return FadeTransition(opacity: animation, child: child);
    // return SlideTransition(position: positionIn(animation), child: child);
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(position: positionIn(animation), child: child),
    );
    // return SlideTransition(
    //   position: positionIn(animation),
    //   child: SlideTransition(position: positionOut(secondaryAnimation), child: child),
    // );
  }
}
