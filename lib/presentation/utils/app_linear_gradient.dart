import 'package:flutter/widgets.dart';
import 'package:tailor_made/presentation/theme.dart';

LinearGradient appLinearGradient([bool inverse = false]) {
  return LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: inverse
        ? const <Color>[AppColors.primary, AppColors.accent]
        : const <Color>[AppColors.accent, AppColors.primary],
  );
}
