// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/constants/mk_fonts.dart';
import 'package:tailor_made/constants/mk_style.dart';

/// The TextStyles and Colors used for titles, labels, and descriptions. This
/// InheritedWidget is shared by all of the routes and widgets created for
/// the Mk app.
class MkTheme extends InheritedWidget {
  const MkTheme({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  TextStyle get xxsmall => _text10Style;
  TextStyle get xxsmallHint => xxsmall.copyWith(color: Colors.grey);
  TextStyle get xsmall => _text11Style;
  TextStyle get xsmallHint => xsmall.copyWith(color: Colors.grey);
  TextStyle get small => _text12Style;
  TextStyle get smallMedium => small.copyWith(fontWeight: MkStyle.medium);
  TextStyle get smallSemi => small.copyWith(fontWeight: MkStyle.semibold);
  TextStyle get smallLight => small.copyWith(fontWeight: MkStyle.light);
  TextStyle get smallHint => small.copyWith(color: Colors.grey);
  TextStyle get body1 => _text13Style;
  TextStyle get body2 => body1.copyWith(height: 1.5);
  TextStyle get body3 => _text14Style;
  TextStyle get body3Hint => body3.copyWith(color: Colors.grey);
  TextStyle get body3Light => body3.copyWith(fontWeight: MkStyle.light);
  TextStyle get body3Medium => _text14MediumStyle;
  TextStyle get body3MediumHint => body3Medium.copyWith(color: Colors.grey);
  TextStyle get bodyMedium => body1.copyWith(fontWeight: MkStyle.medium);
  TextStyle get bodySemi => body1.copyWith(fontWeight: MkStyle.semibold);
  TextStyle get bodyBold => body1.copyWith(fontWeight: MkStyle.bold);
  TextStyle get bodyHint => body1.copyWith(color: Colors.grey);
  TextStyle get button => body3Medium;
  TextStyle get title => _header18Style;
  TextStyle get subhead1 => _text15MediumStyle;
  TextStyle get subhead1Semi => _text15SemiStyle;
  TextStyle get subhead1Bold => _text15BoldStyle;
  TextStyle get subhead1Light => _text15LightStyle;
  TextStyle get subhead2 => _text14Style;
  TextStyle get subhead3 => _text16Style;
  TextStyle get subhead3Semi =>
      _text16Style.copyWith(fontWeight: MkStyle.semibold);
  TextStyle get headline => _header20Style;

  TextStyle get appBarTitle => subhead1Bold.copyWith(letterSpacing: .35);

  TextStyle get display1 => _text20Style;
  TextStyle get display1Light => display1.copyWith(fontWeight: MkStyle.light);
  TextStyle get display1Semi => display1.copyWith(fontWeight: MkStyle.semibold);
  TextStyle get display2 => _text24Style.copyWith(height: 1.05);
  TextStyle get display2Semi => display2.copyWith(fontWeight: MkStyle.semibold);
  TextStyle get display2Bold => display2.copyWith(fontWeight: MkStyle.bold);
  TextStyle get display3 => _header28Style;
  TextStyle get display4 => _text32Style;
  TextStyle get display4Light => display4.copyWith(fontWeight: MkStyle.light);
  TextStyle get display4Bold => _header32Style;

  TextStyle get textfield => _text15MediumStyle.copyWith(
        fontWeight: MkStyle.semibold,
        color: MkColors.biro_blue,
      );

  TextStyle get textfieldLabel => body3.copyWith(
        fontWeight: MkStyle.medium,
        height: 0.25,
        color: MkColors.light_grey.withOpacity(.8),
      );
  // TextStyle get errorStyle => small.copyWith(color: Colors.red[700]);
  TextStyle get errorStyle => small.copyWith(color: kBorderSideErrorColor);

  TextStyle get _header18Style => mkFontMedium(18.0);
  TextStyle get _header20Style => mkFontMedium(20.0);
  TextStyle get _header28Style => mkFontMedium(28.0);
  TextStyle get _header32Style => mkFontMedium(32.0);

  TextStyle get _text10Style => mkFontRegular(10.0);
  TextStyle get _text11Style => mkFontRegular(11.0);
  TextStyle get _text12Style => mkFontRegular(12.0);
  TextStyle get _text13Style => mkFontRegular(13.0);
  TextStyle get _text14Style => mkFontRegular(14.0);
  TextStyle get _text14MediumStyle => mkFontMedium(14.0);
  // TextStyle get _text15Style => mkFontRegular(15.0);
  TextStyle get _text15SemiStyle => mkFontSemi(15.0);
  TextStyle get _text15BoldStyle => mkFontBold(15.0);
  TextStyle get _text15LightStyle => mkFontLight(15.0);
  TextStyle get _text15MediumStyle => mkFontMedium(15.0);
  TextStyle get _text16Style => mkFontRegular(16.0);
  // TextStyle get _text16MediumStyle => mkFontMedium(16.0);
  // TextStyle get _text18Style => mkFontRegular(18.0);
  TextStyle get _text20Style => mkFontRegular(20.0);
  TextStyle get _text24Style => mkFontRegular(24.0);
  TextStyle get _text32Style => mkFontRegular(32.0);

  static MkTheme of(BuildContext context) =>
      context.inheritFromWidgetOfExactType(MkTheme);

  ThemeData themeData(ThemeData theme) {
    return ThemeData(
      accentColor: kAccentColor,
      primarySwatch: kPrimarySwatch,
      primaryColor: kPrimaryColor,
      primaryIconTheme: theme.primaryIconTheme.copyWith(
        color: kPrimarySwatch,
      ),
      textTheme: theme.textTheme.copyWith(
        body1: theme.textTheme.body1.merge(
          body1,
        ),
        button: theme.textTheme.button.merge(
          button,
        ),
      ),
      canvasColor: Colors.white,
      buttonTheme: theme.buttonTheme.copyWith(
        height: 48.0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: false,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimarySwatch, width: 2.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kBorderSideColor),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kBorderSideErrorColor),
        ),
        contentPadding: EdgeInsets.only(top: 13.0, bottom: 12.0),
        hintStyle: textfieldLabel,
        labelStyle: textfieldLabel,
        errorStyle: errorStyle,
      ),
      cursorColor: kPrimaryColor,
      fontFamily: MkFonts.base,
      hintColor: kHintColor,
      dividerColor: kBorderSideColor,
    );
  }

  @override
  bool updateShouldNotify(MkTheme oldWidget) => false;
}
