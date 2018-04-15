import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';

IconButton backButton(BuildContext context) {
  final TMTheme theme = TMTheme.of(context);
  return new IconButton(
    icon: new Icon(
      Icons.arrow_back,
      color: theme.appBarColor,
    ),
    onPressed: () => Navigator.maybePop(context),
  );
}
