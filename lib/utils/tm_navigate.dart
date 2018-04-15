import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class TMNavigate {
  TMNavigate._();

  static void android(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => TMTheme(child: widget)),
    );
  }

  static void ios(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (BuildContext context) => TMTheme(child: widget)),
    );
  }
}
