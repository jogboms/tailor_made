import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/theme.dart';

const Color kAccentColor = AppColors.accent;
const Color kPrimaryColor = AppColors.primary;

const MaterialColor kAccentSwatch = AppColors.slatePink;
const MaterialColor kPrimarySwatch = AppColors.biroBlue;

const Color kHintColor = Color(0xFFAAAAAA);
const Color kDividerColor = Color(0xFFBDBDBD);
const Color kBorderSideColor = Color(0x66D1D1D1);
final Color kBorderSideErrorColor = kAccentSwatch.shade900;
const Color kTextBaseColor = AppColors.dark;
const Color kTitleBaseColor = kTextBaseColor;
const Color kBackgroundBaseColor = Colors.white;
const Color kAppBarBackgroundColor = Colors.white;

const double kBaseScreenHeight = 896.0;
const double kBaseScreenWidth = 414.0;

const double kButtonHeight = 48.0;
const double kButtonMinWidth = 200.0;

const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(4.0));

class AppBorderSide extends BorderSide {
  const AppBorderSide({Color? color, BorderStyle? style, double? width})
      : super(
          color: color ?? kBorderSideColor,
          style: style ?? BorderStyle.solid,
          width: width ?? 1.0,
        );
}

class AppStyle extends TextStyle {
  const AppStyle.font({super.fontSize, FontWeight? fontWeight, Color? color})
      : super(
          inherit: false,
          color: color ?? kTextBaseColor,
          fontFamily: AppFonts.base,
          fontWeight: fontWeight ?? AppStyle.regular,
          // wordSpacing: -2.5,
          // letterSpacing: -0.5,
          textBaseline: TextBaseline.alphabetic,
        );

  static const FontWeight light = FontWeight.w200;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w600;
  static const FontWeight semibold = FontWeight.w700;
  static const FontWeight bold = FontWeight.w900;
}

TextStyle appFontColor(Color color) => AppStyle.font(color: color);

TextStyle appFontLight(double fontSize, [Color? color]) =>
    AppStyle.font(fontSize: fontSize, fontWeight: AppStyle.light, color: color ?? kTextBaseColor);

TextStyle appFontRegular(double fontSize, [Color? color]) =>
    AppStyle.font(fontSize: fontSize, fontWeight: AppStyle.regular, color: color ?? kTextBaseColor);

TextStyle appFontMedium(double fontSize, [Color? color]) =>
    AppStyle.font(fontSize: fontSize, fontWeight: AppStyle.medium, color: color ?? kTextBaseColor);

TextStyle appFontSemi(double fontSize, [Color? color]) =>
    AppStyle.font(fontSize: fontSize, fontWeight: AppStyle.semibold, color: color ?? kTextBaseColor);

TextStyle appFontBold(double fontSize, [Color? color]) =>
    AppStyle.font(fontSize: fontSize, fontWeight: AppStyle.bold, color: color ?? kTextBaseColor);
