import 'package:flutter/material.dart' show MaterialColor;
import 'package:flutter/widgets.dart';

class MkColors {
  MkColors._();
  static const _baseBlue = 0xFF9168ed;
  static const _basePink = 0xFFe00092;
  static const MaterialColor dark = const MaterialColor(
    0xFF444444,
    const <int, Color>{
      50: const Color(0xFFfafafa),
      100: const Color(0xFFf5f5f5),
      200: const Color(0xFFefefef),
      300: const Color(0xFFe2e2e2),
      400: const Color(0xFFbfbfbf),
      500: const Color(0xFFa0a0a0),
      600: const Color(0xFF777777),
      700: const Color(0xFF636363),
      800: const Color(0xFF444444),
      900: const Color(0xFF232323),
    },
  );
  static const MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50: const Color(0xFFFFFFFF),
      100: const Color(0xFFfafafa),
      200: const Color(0xFFf5f5f5),
      300: const Color(0xFFf0f0f0),
      400: const Color(0xFFdedede),
      500: const Color(0xFFc2c2c2),
      600: const Color(0xFF979797),
      700: const Color(0xFF818181),
      800: const Color(0xFF606060),
      900: const Color(0xFF3c3c3c),
    },
  );
  static const MaterialColor biro_blue = const MaterialColor(
    _baseBlue,
    const <int, Color>{
      50: const Color(0xFFeee5fc),
      100: const Color(0xFFd1bff6),
      200: const Color(0xFFb295f1),
      300: const Color(_baseBlue),
      400: const Color(0xFF7644e9),
      500: const Color(0xFF5519e4),
      600: const Color(0xFF4815de),
      700: const Color(0xFF3009d5),
      800: const Color(0xFF0000d0),
      900: const Color(0xFF0000ca),
    },
  );
  static const MaterialColor slate_pink = const MaterialColor(
    _basePink,
    const <int, Color>{
      50: const Color(0xFFf8e1f0),
      100: const Color(0xFFefb5da),
      200: const Color(0xFFe783c1),
      300: const Color(0xFFe24ca7),
      400: const Color(_basePink),
      500: const Color(0xFFe0007a),
      600: const Color(0xFFcf0076),
      700: const Color(0xFFb8006f),
      800: const Color(0xFFa2006a),
      900: const Color(0xFF7a0060),
    },
  );
  static const Color accent = const Color(_basePink);
  static const Color primary = const Color(_baseBlue);
  static const Color light_grey = const Color(0xFF9B9B9B);
  static const Color danger = const Color(0xFFEB5757);
  static const Color info = const Color(0xFF2D9CDB);
  static const Color warning = const Color(0xFFF1B61E);
  static const Color gold = const Color(0xFFD58929);
}
