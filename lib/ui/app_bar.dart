import 'package:flutter/material.dart';
import 'package:tailor_made/ui/back_button.dart';
import 'package:tailor_made/utils/tm_theme.dart';

AppBar appBar(BuildContext context, {String title, List<Widget> actions}) {
  final TMTheme theme = TMTheme.of(context);
  return AppBar(
    elevation: 1.0,
    backgroundColor: theme.appBarBackgroundColor,
    leading: backButton(context),
    title: new Text(
      title,
      style: theme.appBarStyle.copyWith(
          // letterSpacing: 0.95,
          ),
    ),
    actions: actions?.length != null ? actions : [],
  );
}
