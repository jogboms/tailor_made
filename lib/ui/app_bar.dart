import 'package:flutter/material.dart';
import 'package:tailor_made/ui/back_button.dart';

AppBar appBar(BuildContext context, {String title, List<Widget> actions}) {
  return AppBar(
    // elevation: 0.0,
    leading: backButton(context),
    title: new Text(
      title,
      style: new TextStyle(
        color: Colors.grey.shade800,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.95,
      ),
    ),
    actions: actions?.length != null ? actions : [],
  );
}
