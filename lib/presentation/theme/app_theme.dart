import 'package:flutter/material.dart';

import 'app_border_radius.dart';
import 'app_fonts.dart';
import 'app_style.dart';

const Color _kAccentColor = Color(0xFFe00092);
const Color _kPrimaryColor = Color(0xFF9168ed);
const Color _kBorderSideErrorColor = Color(0xFF7a0060);
const Color _kHintColor = Color(0xFFAAAAAA);
const double _kIconSize = 28.0;
const double _kButtonHeight = 48.0;

class AppColorTheme {
  const AppColorTheme._();

  final Color success = const Color(0xFF239f77);
  final Color onSuccess = const Color(0xFFFFFFFF);

  final Color warning = const Color(0xFFFF8C00);
  final Color onWarning = const Color(0xFFFFFFFF);

  final Color danger = const Color(0xFFEB5757);
  final Color onDanger = const Color(0xFFFFFFFF);

  final Color borderSideColor = const Color(0x66D1D1D1);
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
  final Brightness brightness = defaultTheme.brightness;
  final ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: _kPrimaryColor,
    secondary: _kAccentColor,
    brightness: brightness,
  );

  final TextTheme textTheme = defaultTheme.textTheme.apply(fontFamily: AppFonts.base);

  final TextStyle? buttonTextStyle = textTheme.labelMedium?.copyWith(
    fontWeight: AppFontWeight.semibold,
  );
  final ButtonStyle buttonStyle = ButtonStyle(
    textStyle: MaterialStateProperty.all(buttonTextStyle),
    elevation: MaterialStateProperty.all(0),
  );

  return ThemeData(
    primaryColor: _kPrimaryColor,
    iconTheme: defaultTheme.iconTheme.copyWith(size: _kIconSize),
    primaryIconTheme: defaultTheme.primaryIconTheme.copyWith(size: _kIconSize),
    textTheme: defaultTheme.textTheme.merge(textTheme),
    primaryTextTheme: defaultTheme.primaryTextTheme.merge(textTheme),
    shadowColor: colorScheme.scrim,
    appBarTheme: defaultTheme.appBarTheme.copyWith(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 1.0,
    ),
    textButtonTheme: TextButtonThemeData(style: buttonStyle),
    filledButtonTheme: FilledButtonThemeData(style: buttonStyle),
    buttonTheme: defaultTheme.buttonTheme.copyWith(height: _kButtonHeight),
    colorScheme: colorScheme,
    inputDecorationTheme: InputDecorationTheme(
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _kPrimaryColor, width: 2.0)),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: appTheme.color.borderSideColor)),
      errorBorder: const UnderlineInputBorder(borderSide: BorderSide(color: _kBorderSideErrorColor)),
      contentPadding: const EdgeInsets.only(top: 13.0, bottom: 12.0),
    ),
    fontFamily: AppFonts.base,
    hintColor: _kHintColor,
    dividerTheme: defaultTheme.dividerTheme.copyWith(
      color: appTheme.color.borderSideColor,
      thickness: 1,
    ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: _kPrimaryColor),
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

extension TextThemeExtensions on TextTheme {
  TextStyle get bodySmallMedium => bodySmall!.copyWith(fontWeight: AppFontWeight.medium);

  TextStyle get bodySmallLight => bodySmall!.copyWith(fontWeight: AppFontWeight.light);

  TextStyle get pageTitle => titleMedium!.copyWith(fontWeight: AppFontWeight.bold, fontSize: 18.0);
}
