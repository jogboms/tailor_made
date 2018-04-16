import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_fonts.dart';
import 'package:tailor_made/pages/homepage/homepage.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_strings.dart';
import 'package:tailor_made/utils/tm_theme.dart';

void main() => runApp(new TMApp());

class TMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    );
  }
}
