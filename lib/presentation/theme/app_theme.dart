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
