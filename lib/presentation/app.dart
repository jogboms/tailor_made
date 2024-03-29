import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:registry/registry.dart';
import 'package:tailor_made/core.dart';

import 'routing.dart';
import 'screens/splash/splash.dart';
import 'theme.dart';
import 'utils.dart';
import 'widgets.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.registry,
    this.home,
    this.navigatorObservers,
  });

  final Registry registry;
  final Widget? home;
  final List<NavigatorObserver>? navigatorObservers;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  late final Environment _environment = widget.registry.get();
  late final String _bannerMessage = _environment.name.toUpperCase();

  @override
  Widget build(BuildContext context) {
    return _Banner(
      key: Key(_bannerMessage),
      visible: !_environment.isProduction,
      message: _bannerMessage,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        color: Colors.white,
        navigatorKey: _navigatorKey,
        navigatorObservers: widget.navigatorObservers ?? <NavigatorObserver>[],
        theme: themeBuilder(ThemeData.light()),
        darkTheme: themeBuilder(ThemeData.dark()),
        onGenerateTitle: (BuildContext context) => context.l10n.appName,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          L10n.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.supportedLocales,
        builder: (_, Widget? child) => SnackBarProvider(
          navigatorKey: _navigatorKey,
          child: child!,
        ),
        onGenerateRoute: (RouteSettings settings) => _PageRoute<Object>(
          builder: (_) => widget.home ?? const SplashPage(isColdStart: true),
          settings: RouteSettings(name: AppRoutes.start, arguments: settings.arguments),
        ),
      ),
    );
  }
}

class _PageRoute<T extends Object> extends MaterialPageRoute<T> {
  _PageRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(_, Animation<double> animation, __, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(animation),
        child: child,
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner({super.key, required this.visible, required this.message, required this.child});

  final bool visible;
  final String message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return child;
    }

    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.topCenter,
      children: <Widget>[
        child,
        CustomPaint(
          painter: BannerPainter(
            message: message,
            textDirection: TextDirection.ltr,
            layoutDirection: TextDirection.ltr,
            location: BannerLocation.topStart,
            color: const Color(0xFFA573E3),
          ),
        ),
      ],
    );
  }
}
