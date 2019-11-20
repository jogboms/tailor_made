import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_routes.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/screens/splash/splash.dart';
import 'package:tailor_made/utils/mk_scale_util.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class App extends StatefulWidget {
  App({
    @required this.store,
    @required this.navigatorKey,
    @required this.version,
    this.navigatorObservers,
  }) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  final Store<AppState> store;
  final List<NavigatorObserver> navigatorObservers;
  final GlobalKey<NavigatorState> navigatorKey;
  final String version;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
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
              title: MkStrings.appName,
              color: Colors.white,
              navigatorKey: widget.navigatorKey,
              navigatorObservers: widget.navigatorObservers ?? [],
              theme: ThemeProvider.of(context).themeData(Theme.of(context)),
              builder: (_, child) => Builder(builder: (BuildContext context) {
                MkScaleUtil.initialize(context: context, size: Size(1080, 1920));
                return child;
              }),
              onGenerateRoute: (RouteSettings settings) => _PageRoute(
                builder: (_) => SplashPage(isColdStart: true, version: widget.version),
                settings: settings.copyWith(name: MkRoutes.start),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PageRoute<T extends Object> extends MaterialPageRoute<T> {
  _PageRoute({WidgetBuilder builder, RouteSettings settings}) : super(builder: builder, settings: settings);

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
