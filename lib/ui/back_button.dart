import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';

IconButton backButton(BuildContext context, {Color color}) {
  final TMTheme theme = TMTheme.of(context);
  return new IconButton(
    icon: new Icon(
      Icons.arrow_back,
      color: color != null ? color : theme.appBarColor,
    ),
    onPressed: () => Navigator.maybePop(context),
  );
}
