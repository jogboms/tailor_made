import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tailor_made/pages/homepage/homepage.dart';
import 'package:tailor_made/redux/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/utils/tm_fonts.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_strings.dart';
import 'package:tailor_made/utils/tm_theme.dart';

void main() => runApp(new TMApp());

class TMApp extends StatelessWidget {
  final Store<ReduxState> store = reduxStore();

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<ReduxState>(
      store: store,
      child: MaterialApp(
        title: TMStrings.appName,
        theme: new ThemeData(
          accentColor: accentColor,
          primarySwatch: primarySwatch,
          fontFamily: TMFonts.raleway,
        ),
        onGenerateRoute: (RouteSettings settings) {
          return new TMNavigateRoute(
            builder: (_) => TMTheme(child: HomePage()),
            settings: settings,
          );
        },
        // home: TMTheme(child: HomePage()),
      ),
    );
  }
}
