// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_colors.dart';

const Color kAccentColor = TMColors.accent;
const Color kPrimaryColor = TMColors.primary;

const MaterialColor kAccentSwatch = TMColors.slate_pink;
const MaterialColor kPrimarySwatch = TMColors.biro_blue;

final Color kBorderSideColor = Colors.grey.shade300;
const MaterialColor kTextBaseColor = Colors.grey;
const MaterialColor kTitleBaseColor = TMColors.dark;
const MaterialColor kBackgroundBaseColor = TMColors.white;

class TMBorderSide extends BorderSide {
  TMBorderSide({Color color})
      : super(
          color: color != null ? color : kBorderSideColor,
          style: BorderStyle.solid,
          width: 1.0,
        );
}

class TMStyle extends TextStyle {
  const TMStyle.raleway(double size, FontWeight weight, Color color)
      : super(
            inherit: false,
            color: color,
            fontFamily: 'Raleway',
            fontSize: size,
            fontWeight: weight,
            textBaseline: TextBaseline.alphabetic);
}

TextStyle ralewayThin(double fontSize, [Color color]) =>
    new TMStyle.raleway(fontSize, FontWeight.w100, color ?? kTextBaseColor);
TextStyle ralewayLight(double fontSize, [Color color]) =>
    new TMStyle.raleway(fontSize, FontWeight.w300, color ?? kTextBaseColor);
TextStyle ralewayRegular(double fontSize, [Color color]) =>
    new TMStyle.raleway(fontSize, FontWeight.w400, color ?? kTextBaseColor);
TextStyle ralewayMedium(double fontSize, [Color color]) =>
    new TMStyle.raleway(fontSize, FontWeight.w500, color ?? kTextBaseColor);
TextStyle ralewayBold(double fontSize, [Color color]) =>
    new TMStyle.raleway(fontSize, FontWeight.w700, color ?? kTextBaseColor);

/// The TextStyles and Colors used for titles, labels, and descriptions. This
/// InheritedWidget is shared by all of the routes and widgets created for
/// the TM app.
class TMTheme extends InheritedWidget {
  TMTheme({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  Color get accentColor => kAccentColor;
  Color get primaryColor => kPrimaryColor;
  Color get borderSideColor => kBorderSideColor;
  Color get appBarBackgroundColor => scaffoldColor;

  final Color scaffoldColor = kBackgroundBaseColor;
  final Color scaffoldColorAlt = kTextBaseColor.shade100;
  final Color appBarColor = kTitleBaseColor;
  final Color textColor = kTextBaseColor.shade800;
  final Color textMutedColor = kTextBaseColor.shade500;

  TextStyle get appBarStyle => ralewayBold(20.0, appBarColor);
  TextStyle get titleStyle => ralewayMedium(18.0, kTitleBaseColor);
  TextStyle get smallTextStyle => ralewayRegular(12.0, textColor);
  TextStyle get mediumTextStyle => ralewayRegular(16.0, textColor);

  static TMTheme of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(TMTheme);

  @override
  bool updateShouldNotify(TMTheme oldWidget) => false;
}
