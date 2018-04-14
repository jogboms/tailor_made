import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_colors.dart';
import 'package:tailor_made/utils/tm_fonts.dart';
import 'package:tailor_made/pages/homepage.dart';
import 'package:tailor_made/utils/tm_strings.dart';

void main() => runApp(
      MaterialApp(
        title: TMStrings.appName,
        theme: new ThemeData(
          accentColor: TMColors.primary,
          primarySwatch: TMColors.white,
          fontFamily: TMFonts.raleway,
        ),
        home: HomePage(),
      ),
    );
