import 'package:flutter/material.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/presentation/utils/scale_util.dart';

import 'constants/app_routes.dart';
import 'constants/app_strings.dart';
import 'rebloc/app_state.dart';
import 'rebloc/common/actions.dart';
import 'screens/splash/splash.dart';
import 'theme/theme_provider.dart';

class App extends StatefulWidget {
  const App({
    super.key,
    required this.dependencies,
    required this.navigatorKey,
    required this.store,
    this.navigatorObservers,
  });

  final Dependencies dependencies;
  final GlobalKey<NavigatorState> navigatorKey;
  final Store<AppState> store;
  final List<NavigatorObserver>? navigatorObservers;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final Environment environment = widget.dependencies.get();

  @override
  void dispose() {
    widget.store.dispatch(const OnDisposeAction());
    widget.store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      child: StoreProvider<AppState>(
        store: widget.store,
        child: FirstBuildDispatcher<AppState>(
          // Initialize action
          action: const OnInitAction(),
          child: Builder(
            builder: (BuildContext context) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: AppStrings.appName,
              color: Colors.white,
              navigatorKey: widget.navigatorKey,
              navigatorObservers: widget.navigatorObservers ?? <NavigatorObserver>[],
              theme: ThemeProvider.of(context)!.themeData(Theme.of(context)),
              builder: (_, Widget? child) => Builder(
                builder: (BuildContext context) {
                  ScaleUtil.initialize(context: context, size: const Size(1080, 1920));
                  return child!;
                },
              ),
              onGenerateRoute: (RouteSettings settings) => _PageRoute<Object>(
                builder: (_) => SplashPage(isColdStart: true, isMock: environment.isMock),
                settings: settings.copyWith(name: AppRoutes.start),
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
