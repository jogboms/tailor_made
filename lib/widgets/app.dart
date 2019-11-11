import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_routes.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/store_factory.dart';
import 'package:tailor_made/screens/splash/splash.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_screen_util.dart';
import 'package:tailor_made/widgets/bootstrap.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class App extends StatefulWidget {
  App({@required this.bootstrap}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  final BootstrapModel bootstrap;

  @override
  _AppState createState() => _AppState(bootstrap);
}

class _AppState extends State<App> {
  _AppState(this._bs) : store = storeFactory();

  final BootstrapModel _bs;
  final Store<AppState> store;

  final MkScreenUtilConfig screenConfig = const MkScreenUtilConfig(width: 412, height: 732, allowFontScaling: true);

  @override
  void dispose() {
    store.dispatcher(const OnDisposeAction());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      child: StoreProvider<AppState>(
        store: store,
        child: FirstBuildDispatcher<AppState>(
          // Initialize action
          action: const OnInitAction(),
          child: Builder(
            builder: (BuildContext context) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: MkStrings.appName,
              color: Colors.white,
              theme: ThemeProvider.of(context).themeData(Theme.of(context)),
              builder: (context, child) => Builder(builder: (BuildContext context) {
                MkScreenUtil.initialize(context: context, config: screenConfig);
                return child;
              }),
              onGenerateRoute: (RouteSettings settings) {
                return MkNavigateRoute<dynamic>(
                  builder: (_) {
                    if (_bs.isTestMode) {
                      return const SizedBox();
                    }

                    return SplashPage(isColdStart: true);
                  },
                  settings: settings.copyWith(name: MkRoutes.start, isInitialRoute: true),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
