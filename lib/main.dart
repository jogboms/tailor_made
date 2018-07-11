import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:tailor_made/pages/homepage/homepage.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/utils/tm_fonts.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_strings.dart';
import 'package:tailor_made/utils/tm_theme.dart';

void main() {
  FirebaseAuth.instance.signInAnonymously().then((r) {
    print(r);
  });

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
          accentColor: kAccentColor,
          primarySwatch: kPrimarySwatch,
          fontFamily: TMFonts.raleway,
        ),
        onGenerateRoute: (RouteSettings settings) {
          return new TMNavigateRoute(
            builder: (_) => TMTheme(
                  child: new StoreBuilder<ReduxState>(
                    onInit: (store) => store.dispatch(new InitDataEvents()),
                    onDispose: (store) => store.dispatch(new DisposeDataEvents()),
                    builder: (BuildContext context, store) {
                      return HomePage();
                    },
                  ),
                ),
            settings: settings,
          );
        },
        // home: TMTheme(child: HomePage()),
      ),
    );
  }
}
