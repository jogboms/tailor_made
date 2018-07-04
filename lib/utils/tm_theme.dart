// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_colors.dart';

const Color accentColor = TMColors.primary;
const Color accentColorAlt = Colors.blueGrey;
const MaterialColor primarySwatch = TMColors.green;
final Color borderSideColor = Colors.grey.shade300;
const MaterialColor textBaseColor = Colors.grey;
const MaterialColor titleBaseColor = TMColors.dark;
const MaterialColor backgroundBaseColor = TMColors.white;

class TMBorderSide extends BorderSide {
  TMBorderSide({Color color})
      : super(
          color: color != null ? color : borderSideColor,
          style: BorderStyle.solid,
          width: 1.0,
        );
}

class TMStyle extends TextStyle {
  const TMStyle.raleway(double size, FontWeight weight, Color color)
      : super(inherit: false, color: color, fontFamily: 'Raleway', fontSize: size, fontWeight: weight, textBaseline: TextBaseline.alphabetic);
}

TextStyle ralewayThin(double fontSize, [Color color]) => new TMStyle.raleway(fontSize, FontWeight.w100, color ?? textBaseColor);
TextStyle ralewayLight(double fontSize, [Color color]) => new TMStyle.raleway(fontSize, FontWeight.w300, color ?? textBaseColor);
TextStyle ralewayRegular(double fontSize, [Color color]) => new TMStyle.raleway(fontSize, FontWeight.w400, color ?? textBaseColor);
TextStyle ralewayMedium(double fontSize, [Color color]) => new TMStyle.raleway(fontSize, FontWeight.w500, color ?? textBaseColor);
TextStyle ralewayBold(double fontSize, [Color color]) => new TMStyle.raleway(fontSize, FontWeight.w700, color ?? textBaseColor);

/// The TextStyles and Colors used for titles, labels, and descriptions. This
/// InheritedWidget is shared by all of the routes and widgets created for
/// the TM app.
class TMTheme extends InheritedWidget {
  TMTheme({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  Color get accentColor => TMColors.accent;
  Color get primaryColor => TMColors.primary;
  Color get borderSideColor => borderSideColor;
  Color get appBarBackgroundColor => scaffoldColor;

  final Color scaffoldColor = backgroundBaseColor;
  final Color scaffoldColorAlt = textBaseColor.shade100;
  final Color appBarColor = titleBaseColor;
  final Color textColor = textBaseColor.shade800;
  final Color textMutedColor = textBaseColor.shade500;

  // final Color scaffoldColor = Color(0xFF00251a);
  // final Color scaffoldColorAlt = Colors.blueGrey.shade700;
  // final Color appBarColor = Color(0xFF39796b);
  // final Color textColor = Color(0xFF39796b);

  TextStyle get appBarStyle => ralewayBold(20.0, appBarColor);
  TextStyle get titleStyle => ralewayMedium(18.0, titleBaseColor);
  TextStyle get smallTextStyle => ralewayRegular(12.0, textColor);
  TextStyle get mediumTextStyle => ralewayRegular(16.0, textColor);

  static TMTheme of(BuildContext context) => context.inheritFromWidgetOfExactType(TMTheme);

  @override
  bool updateShouldNotify(TMTheme oldWidget) => false;
}
