import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TMColors {
  TMColors._();

  static const MaterialColor dark = const MaterialColor(
    0xFF444444,
    const <int, Color>{
      50: const Color(0xFF444444),
      100: const Color(0xFF888888),
      200: const Color(0xFF777777),
      300: const Color(0xFF666666),
      400: const Color(0xFF555555),
      500: const Color(0xFF444444),
      600: const Color(0xFF333333),
      700: const Color(0xFF222222),
      800: const Color(0xFF111111),
      900: const Color(0xFF000000),
    },
  );
  static const MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFFFFFFF),
      200: const Color(0xFFFFFFFF),
      300: const Color(0xFFFFFFFF),
      400: const Color(0xFFFFFFFF),
      500: const Color(0xFFFFFFFF),
      600: const Color(0xFFFDFDFD),
      700: const Color(0xFFFAFAFA),
      800: const Color(0xFFF6F6F6),
      900: const Color(0xFFF0F0F0),
    },
  );
  static const MaterialColor green = const MaterialColor(
    0xFF4caf50,
    const <int, Color>{
      50: const Color(0xFF4caf50),
      100: const Color(0xFF4caf50),
      200: const Color(0xFF4caf50),
      300: const Color(0xFF4caf50),
      400: const Color(0xFF4caf50),
      500: const Color(0xFF4caf50),
      600: const Color(0xFF4caf50),
      700: const Color(0xFF4caf50),
      800: const Color(0xFF4caf50),
      900: const Color(0xFF4caf50),
    },
  );
  static const Color accent = const Color(0xFF4caf50);
  static const Color primary = const Color(0xFF4caf50);
}
