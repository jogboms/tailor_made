import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class TMPageRoute {
  static CupertinoPageRoute slideIn<T>(
    Widget widget, {
    RouteSettings settings,
    bool maintainState: true,
    bool fullscreenDialog: false,
    PageRoute hostRoute,
  }) {
    return CupertinoPageRoute<T>(
      builder: (BuildContext context) => TMTheme(child: widget),
      settings: settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      hostRoute: hostRoute,
    );
  }

  static PageRouteBuilder fadeIn<T>(
    Widget widget, {
    RouteSettings settings,
    bool maintainState: true,
  }) {
    return PageRouteBuilder<T>(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) => TMTheme(child: widget),
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return new FadeTransition(opacity: animation, child: child);
      },
      settings: settings,
      maintainState: maintainState,
    );
  }
}

class TMNavigate {
  TMNavigate(
    BuildContext context,
    Widget widget, {
    String name,
    RouteSettings settings,
    bool maintainState: true,
    bool fullscreenDialog: false,
    PageRoute hostRoute,
  }) {
    Navigator.push<dynamic>(
      context,
      TMNavigate.slideIn<dynamic>(
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
    bool maintainState: true,
    bool fullscreenDialog: false,
    PageRoute hostRoute,
  }) {
    final _settings = name != null ? new RouteSettings(name: name) : settings;
    return TMPageRoute.slideIn<T>(
      widget,
      settings: _settings,
      maintainState: maintainState,
      fullscreenDialog: fullscreenDialog,
      hostRoute: hostRoute,
    );
  }

  static Route fadeIn<T>(
    Widget widget, {
    String name,
    RouteSettings settings,
    bool maintainState: true,
  }) {
    final _settings = name != null ? new RouteSettings(name: name) : settings;
    return TMPageRoute.fadeIn<T>(
      widget,
      settings: _settings,
      maintainState: maintainState,
    );
  }
}

class TMNavigateRoute<T> extends MaterialPageRoute<T> {
  TMNavigateRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> positionIn(Animation<double> animation) => new Tween<Offset>(
          // begin: const Offset(1.0, 0.0),
          // begin: const Offset(0.0, 1.0),
          begin: const Offset(0.0, 0.3),
          end: Offset.zero,
        ).animate(animation);

    // Animation<Offset> positionOut(Animation<double> animation) => new Tween<Offset>(
    //       begin: Offset.zero,
    //       end: Offset.zero,
    //     ).animate(animation);

    if (settings.isInitialRoute) {
      return child;
    }
    // return new FadeTransition(opacity: animation, child: child);
    // return new SlideTransition(position: positionIn(animation), child: child);
    return new FadeTransition(
      opacity: animation,
      child: new SlideTransition(position: positionIn(animation), child: child),
    );
    // return new SlideTransition(
    //   position: positionIn(animation),
    //   child: new SlideTransition(position: positionOut(secondaryAnimation), child: child),
    // );
  }
}
