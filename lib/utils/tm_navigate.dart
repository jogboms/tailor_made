import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TMNavigate {
  TMNavigate._();

  static void android(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => widget),
    );
  }

  static void ios(BuildContext context, Widget widget) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (BuildContext context) => widget),
    );
  }
}
