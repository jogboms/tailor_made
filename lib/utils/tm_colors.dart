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
  static const MaterialColor biro_blue = const MaterialColor(
    0xFF0000d0,
    const <int, Color>{
      50: const Color(0xFFeee5fc),
      100: const Color(0xFFd1bff6),
      200: const Color(0xFFb295f1),
      300: const Color(0xFF9168ed),
      400: const Color(0xFF7644e9),
      500: const Color(0xFF5519e4),
      600: const Color(0xFF4815de),
      700: const Color(0xFF3009d5),
      800: const Color(0xFF0000d0),
      900: const Color(0xFF0000ca),
    },
  );
  static const Color accent = const Color(0xFF0000d0);
  static const Color primary = const Color(0xFFf54295);
  static const Color light_grey = const Color(0xFF9B9B9B);
}
