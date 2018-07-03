import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class TMNavigate {
  TMNavigate(
    BuildContext context,
    Widget widget, {
    RouteSettings settings,
    maintainState: true,
    bool fullscreenDialog: false,
    hostRoute,
  }) {
    Navigator.push(
      context,
      // TMNavigateRoute(builder: (BuildContext context) => TMTheme(child: widget)),
      CupertinoPageRoute(
        builder: (BuildContext context) => TMTheme(child: widget),
        settings: settings,
        maintainState: maintainState,
        fullscreenDialog: fullscreenDialog,
        hostRoute: hostRoute,
      ),
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

    if (settings.isInitialRoute) return child;
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
