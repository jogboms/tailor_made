import 'package:flutter/material.dart';

import 'app_border_radius.dart';
import 'app_colors.dart';
import 'app_fonts.dart';
import 'app_style.dart';

@visibleForTesting
class AppColorTheme {
  const AppColorTheme._();

  final Color success = const Color(0xFF239f77);
  final Color onSuccess = const Color(0xFFFFFFFF);

  final Color danger = const Color(0xFFEB5757);
  final Color onDanger = const Color(0xFFFFFFFF);
}

class AppTheme extends ThemeExtension<AppTheme> {
  const AppTheme._();

  final AppColorTheme color = const AppColorTheme._();

  final BorderRadius textFieldBorderRadius = AppBorderRadius.c8;

  @override
  ThemeExtension<AppTheme> copyWith() => this;

  @override
  ThemeExtension<AppTheme> lerp(ThemeExtension<AppTheme>? other, double t) => this;
}

ThemeData themeBuilder(
  ThemeData defaultTheme, {
  AppTheme appTheme = const AppTheme._(),
}) {
  final TextStyle textfieldLabel = appFontRegular(14.0, AppColors.lightGrey.withOpacity(.8)).copyWith(
    fontWeight: AppFontWeight.medium,
    height: 0.25,
  );

  return ThemeData(
    primaryColor: kPrimaryColor,
    primaryIconTheme: defaultTheme.primaryIconTheme.copyWith(color: kPrimarySwatch),
    textTheme: defaultTheme.textTheme.copyWith(
      bodyMedium: defaultTheme.textTheme.bodyMedium!.merge(appFontRegular(13.0)),
      labelLarge: defaultTheme.textTheme.labelLarge!.merge(appFontMedium(14.0)),
    ),
    canvasColor: Colors.white,
    buttonTheme: defaultTheme.buttonTheme.copyWith(height: kButtonHeight),
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kPrimarySwatch, width: 2.0)),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: kBorderSideColor)),
      errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: kBorderSideErrorColor)),
      contentPadding: const EdgeInsets.only(top: 13.0, bottom: 12.0),
      hintStyle: textfieldLabel,
      labelStyle: textfieldLabel,
      errorStyle: appFontRegular(12.0, kBorderSideErrorColor),
    ),
    fontFamily: AppFonts.base,
    hintColor: kHintColor,
    dividerColor: kBorderSideColor,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: kPrimaryColor),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: kPrimarySwatch).copyWith(secondary: kAccentColor),
    extensions: <ThemeExtension<dynamic>>{
      appTheme,
    },
  );
}

extension AppThemeThemeDataExtensions on ThemeData {
  AppTheme get appTheme => extension<AppTheme>()!;
}

extension BuildContextThemeExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension ThemeDataExtensions on ThemeData {
  TextStyle get xxsmall => _text10Style;

  TextStyle get xxsmallHint => xxsmall.copyWith(color: Colors.grey);

  TextStyle get xsmall => _text11Style;

  TextStyle get xsmallHint => xsmall.copyWith(color: Colors.grey);

  TextStyle get small => _text12Style;

  TextStyle get smallMedium => small.copyWith(fontWeight: AppFontWeight.medium);

  TextStyle get smallSemi => small.copyWith(fontWeight: AppFontWeight.semibold);

  TextStyle get smallLight => small.copyWith(fontWeight: AppFontWeight.light);

  TextStyle get smallHint => small.copyWith(color: Colors.grey);

  TextStyle get smallBtn => smallMedium.copyWith(color: AppColors.accent);

  TextStyle get body1 => _text13Style;

  TextStyle get body2 => body1.copyWith(height: 1.5);

  TextStyle get body3 => _text14Style;

  TextStyle get body3Hint => body3.copyWith(color: Colors.grey);

  TextStyle get body3Light => body3.copyWith(fontWeight: AppFontWeight.light);

  TextStyle get body3Medium => _text14MediumStyle;

  TextStyle get body3MediumHint => body3Medium.copyWith(color: Colors.grey);

  TextStyle get bodyMedium => body1.copyWith(fontWeight: AppFontWeight.medium);

  TextStyle get bodySemi => body1.copyWith(fontWeight: AppFontWeight.semibold);

  TextStyle get bodyBold => body1.copyWith(fontWeight: AppFontWeight.bold);

  TextStyle get bodyHint => body1.copyWith(color: Colors.grey);

  TextStyle get button => body3Medium;

  TextStyle get title => _header18Style;

  TextStyle get subhead1 => _text15MediumStyle;

  TextStyle get subhead1Semi => _text15SemiStyle;

  TextStyle get subhead1Bold => _text15BoldStyle;

  TextStyle get subhead1Light => _text15LightStyle;

  TextStyle get subhead2 => _text14Style;

  TextStyle get subhead3 => _text16Style;

  TextStyle get subhead3Semi => _text16Style.copyWith(fontWeight: AppFontWeight.semibold);

  TextStyle get subhead3Light => _text16Style.copyWith(fontWeight: AppFontWeight.light);

  TextStyle get headline => _header20Style;

  TextStyle get appBarTitle => subhead1Bold.copyWith(letterSpacing: .35);

  TextStyle get display1 => _text20Style;

  TextStyle get display1Light => display1.copyWith(fontWeight: AppFontWeight.light);

  TextStyle get display1Semi => display1.copyWith(fontWeight: AppFontWeight.semibold);

  TextStyle get display2 => _text24Style.copyWith(height: 1.05);

  TextStyle get display2Semi => display2.copyWith(fontWeight: AppFontWeight.semibold);

  TextStyle get display2Bold => display2.copyWith(fontWeight: AppFontWeight.bold);

  TextStyle get display3 => _header28Style;

  TextStyle get display4 => _text32Style;

  TextStyle get display4Light => display4.copyWith(fontWeight: AppFontWeight.light);

  TextStyle get display4Bold => _header32Style;

  TextStyle get textfield => _text15MediumStyle.copyWith(fontWeight: AppFontWeight.semibold, color: AppColors.biroBlue);

  TextStyle get textfieldLabel => body3.copyWith(
        fontWeight: AppFontWeight.medium,
        height: 0.25,
        color: AppColors.lightGrey.withOpacity(.8),
      );

  // TextStyle get errorStyle => small.copyWith(color: Colors.red[700]);
  TextStyle get errorStyle => small.copyWith(color: kBorderSideErrorColor);

  TextStyle get _header18Style => appFontMedium(18.0);

  TextStyle get _header20Style => appFontMedium(20.0);

  TextStyle get _header28Style => appFontMedium(28.0);

  TextStyle get _header32Style => appFontMedium(32.0);

  TextStyle get _text10Style => appFontRegular(10.0);

  TextStyle get _text11Style => appFontRegular(11.0);

  TextStyle get _text12Style => appFontRegular(12.0);

  TextStyle get _text13Style => appFontRegular(13.0);

  TextStyle get _text14Style => appFontRegular(14.0);

  TextStyle get _text14MediumStyle => appFontMedium(14.0);

  // TextStyle get _text15Style => mkFontRegular(15.0);
  TextStyle get _text15SemiStyle => appFontSemi(15.0);

  TextStyle get _text15BoldStyle => appFontBold(15.0);

  TextStyle get _text15LightStyle => appFontLight(15.0);

  TextStyle get _text15MediumStyle => appFontMedium(15.0);

  TextStyle get _text16Style => appFontRegular(16.0);

  // TextStyle get _text16MediumStyle => mkFontMedium(16.0);
  // TextStyle get _text18Style => mkFontRegular(18.0);
  TextStyle get _text20Style => appFontRegular(20.0);

  TextStyle get _text24Style => appFontRegular(24.0);

  TextStyle get _text32Style => appFontRegular(32.0);
}
