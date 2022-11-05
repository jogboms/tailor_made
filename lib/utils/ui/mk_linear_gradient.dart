import 'package:flutter/widgets.dart';
import 'package:tailor_made/constants/mk_colors.dart';

LinearGradient mkLinearGradient([bool inverse = false]) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors:
        inverse ? const <Color>[MkColors.primary, MkColors.accent] : const <Color>[MkColors.accent, MkColors.primary],
  );
}
