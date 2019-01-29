import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MkColors {
  MkColors._();
  static const _baseOrange = 0xFFF1B51E;
  static const _baseGreen = 0xFF36A511;
  static const _baseDark = 0xFF4F4F4F;
  static const MaterialColor orange = const MaterialColor(
    _baseOrange,
    const <int, Color>{
      50: const Color(0xFFFEFBE5),
      100: const Color(0xFFFCF5C0),
      200: const Color(0xFFFAEF97),
      300: const Color(0xFFF7E86D),
      400: const Color(0xFFF5E34C),
      500: const Color(0xFFF3DE29),
      600: const Color(0xFFF3CD26),
      700: const Color(_baseOrange),
      800: const Color(0xFFEF9D16),
      900: const Color(0xFFEB7406),
    },
  );
  static const MaterialColor green = const MaterialColor(
    _baseGreen,
    const <int, Color>{
      50: const Color(0xFFEDF9E7),
      100: const Color(0xFFD3F0C2),
      200: const Color(0xFFB5E59B),
      300: const Color(0xFF95DA70),
      400: const Color(0xFF7AD24D),
      500: const Color(0xFF5FCA26),
      600: const Color(0xFF4FB91D),
      700: const Color(_baseGreen),
      800: const Color(0xFF159102),
      900: const Color(0xFF006F00),
    },
  );
  static const MaterialColor dark = const MaterialColor(
    _baseDark,
    const <int, Color>{
      50: const Color(0xFFFCFCFC),
      100: const Color(0xFFF7F7F7),
      200: const Color(0xFFF2F2F2),
      300: const Color(0xFFEDEDED),
      400: const Color(0xFFCBCBCB),
      500: const Color(0xFFAEAEAE),
      600: const Color(0xFF848484),
      700: const Color(0xFF6F6F6F),
      800: const Color(_baseDark),
      900: const Color(0xFF2D2D2D),
    },
  );
  static const Color accent = const Color(_baseOrange);
  static const Color primary = const Color(_baseGreen);
  static const Color light_grey = const Color(0xFF9B9B9B);
  static const Color gradient_start = const Color(0xFFA7C823);
  static const Color gradient_end = const Color(_baseGreen);
  static const Color danger = const Color(0xFFEB5757);
  static const Color info = const Color(0xFF2D9CDB);
  static const Color warning = const Color(0xFFF1B61E);
  static const Color gold = const Color(0xFFD58929);
  static const Map<String, Color> cards = {
    "visa": Color(0xFF1A1F71),
    "verve": Color(0xFF00425F),
    "mastercard": Color(0xFF363935),
  };
}
