import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tailor_made/pages/splash/splash.dart';
import 'package:tailor_made/redux/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/utils/tm_fonts.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_strings.dart';
import 'package:tailor_made/utils/tm_theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  return runApp(new TMApp());
}

class TMApp extends StatelessWidget {
  final Store<ReduxState> store = reduxStore();

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<ReduxState>(
      store: store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: TMStrings.appName,
        theme: new ThemeData(
          primaryColor: Colors.white,
          accentColor: kAccentColor,
          primarySwatch: kPrimarySwatch,
          fontFamily: TMFonts.raleway,
        ),
        onGenerateRoute: (RouteSettings settings) {
          return new TMNavigateRoute<dynamic>(
            builder: (_) => TMTheme(child: SplashPage(isColdStart: true)),
            settings: settings,
          );
        },
      ),
    );
  }
}
