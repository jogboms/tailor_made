import 'package:flutter/material.dart';
import 'package:tailor_made/ui/back_button.dart';
import 'package:tailor_made/utils/tm_theme.dart';

AppBar appBar(
  BuildContext context, {
  String title: "",
  List<Widget> actions,
  double elevation: 1.0,
  bool centerTitle: false,
}) {
  final TMTheme theme = TMTheme.of(context);
  return AppBar(
    elevation: elevation,
    backgroundColor: theme.appBarBackgroundColor,
    leading: backButton(context),
    centerTitle: centerTitle,
    title: new Text(
      title,
      style: theme.appBarStyle.copyWith(
          // letterSpacing: 0.95,
          ),
    ),
    actions: actions?.length != null ? actions : [],
  );
}
