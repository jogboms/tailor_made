import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';

IconButton backButton(
  BuildContext context, {
  Color color,
  VoidCallback onPop,
}) {
  final TMTheme theme = TMTheme.of(context);
  return new IconButton(
    icon: new Icon(
      Icons.arrow_back,
      color: color ?? theme.appBarColor,
    ),
    onPressed: onPop ?? () => Navigator.maybePop(context),
  );
}
