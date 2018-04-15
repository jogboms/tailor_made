// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TMStyle extends TextStyle {
  const TMStyle.raleway(double size, FontWeight weight, Color color)
      : super(inherit: false, color: color, fontFamily: 'Raleway', fontSize: size, fontWeight: weight, textBaseline: TextBaseline.alphabetic);
}

TextStyle ralewayMedium(double fontSize, Color color) => new TMStyle.raleway(fontSize, FontWeight.w500, color);
TextStyle ralewayBold(double fontSize, Color color) => new TMStyle.raleway(fontSize, FontWeight.w700, color);

/// The TextStyles and Colors used for titles, labels, and descriptions. This
/// InheritedWidget is shared by all of the routes and widgets created for
/// the TM app.
class TMTheme extends InheritedWidget {
  TMTheme({Key key, @required Widget child})
      : assert(child != null),
        super(key: key, child: child);

  final Color scaffoldColor = Colors.white;
  final Color scaffoldColorAlt = Colors.grey.shade100;
  final Color appBarColor = Colors.grey.shade800;
  final Color textColor = Colors.grey.shade800;
  final Color appBarBackgroundColor = Colors.white;
  // final Color scaffoldColor = Color(0xFF00251a);
  // final Color scaffoldColorAlt = Colors.blueGrey.shade700;
  // final Color appBarColor = Color(0xFF39796b);
  // final Color textColor = Color(0xFF39796b);
  // Color get appBarBackgroundColor => scaffoldColor;

  TextStyle get appBarStyle => ralewayMedium(20.0, appBarColor);

  static TMTheme of(BuildContext context) => context.inheritFromWidgetOfExactType(TMTheme);

  @override
  bool updateShouldNotify(TMTheme oldWidget) => false;
}
