import 'package:flutter/widgets.dart';
import 'package:tailor_made/constants/mk_colors.dart';

LinearGradient mkLinearGradient([bool inverse = false]) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: inverse
        ? const [
            MkColors.primary,
            MkColors.accent,
          ]
        : const [
            MkColors.accent,
            MkColors.primary,
          ],
  );
}
