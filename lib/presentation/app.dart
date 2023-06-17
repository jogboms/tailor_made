import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/core.dart';

import 'constants.dart';
import 'rebloc.dart';
import 'registry.dart';
import 'screens/splash/splash.dart';
import 'theme.dart';
import 'utils.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.registry,
    required this.navigatorKey,
    required this.store,
    this.navigatorObservers,
  });

  final Registry registry;
  final GlobalKey<NavigatorState> navigatorKey;
  final Store<AppState> store;
  final List<NavigatorObserver>? navigatorObservers;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final Environment environment = widget.registry.get();
  late final String bannerMessage = environment.name.toUpperCase();

  @override
  void initState() {
    super.initState();
    widget.store.dispatch(const OnInitAction());
  }

  @override
  void dispose() {
    widget.store
      ..dispatch(const OnDisposeAction())
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RegistryProvider(
      registry: widget.registry,
      child: ThemeProvider(
        child: StoreProvider<AppState>(
          store: widget.store,
          child: Builder(
            builder: (BuildContext context) => _Banner(
              key: Key(bannerMessage),
              visible: !environment.isProduction,
              message: bannerMessage,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                color: Colors.white,
                navigatorKey: widget.navigatorKey,
                navigatorObservers: widget.navigatorObservers ?? <NavigatorObserver>[],
                theme: ThemeProvider.of(context)!.themeData(Theme.of(context)),
                onGenerateTitle: (BuildContext context) => context.l10n.appName,
                localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                  L10n.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: L10n.supportedLocales,
                builder: (_, Widget? child) => Builder(
                  builder: (BuildContext context) {
                    ScaleUtil.initialize(context: context, size: const Size(1080, 1920));
                    return child!;
                  },
                ),
                onGenerateRoute: (RouteSettings settings) => _PageRoute<Object>(
                  builder: (_) => SplashPage(isColdStart: true, isMock: environment.isMock),
                  settings: RouteSettings(name: AppRoutes.start, arguments: settings.arguments),
                ),
              ),
            ),
          ),
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
