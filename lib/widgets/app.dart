import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/constants/mk_routes.dart';
import 'package:tailor_made/constants/mk_strings.dart';
import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/utils/mk_settings.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/main.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/utils/mk_navigate.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/screens/splash/splash.dart';

class BootstrapModel {
  const BootstrapModel({
    @required this.isFirstTime,
  });

  final bool isFirstTime;
}

class App extends StatefulWidget {
  App({
    @required Environment env,
    @required this.isFirstTime,
  }) {
    MkSettings.environment = env;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  final bool isFirstTime;

  static Future<BootstrapModel> bootstrap() async {
    final isFirstTime = await MkSettings.checkIsFirstTimeLogin();
    try {
      await MkSettings.initVersion();
    } catch (e) {
      //
    }

    return BootstrapModel(isFirstTime: isFirstTime);
  }

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Store<AppState> store = reblocStore();

  @override
  void dispose() {
    store.dispatcher(const OnDisposeAction());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MkTheme(
      child: StoreProvider<AppState>(
        store: store,
        child: FirstBuildDispatcher<AppState>(
          // Initialize action
          action: const OnInitAction(),
          child: Builder(
            builder: (BuildContext context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: MkStrings.appName,
                color: Colors.white,
                theme: MkTheme.of(context).themeData(Theme.of(context)),
                onGenerateRoute: (RouteSettings settings) {
                  return MkNavigateRoute<dynamic>(
                    builder: (_) {
                      return SplashPage(isColdStart: true);
                    },
                    settings: settings.copyWith(
                      name: MkRoutes.start,
                      isInitialRoute: true,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
