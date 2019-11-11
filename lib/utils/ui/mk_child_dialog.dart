import 'dart:async' show Future;

import 'package:flutter/material.dart' show required, BuildContext, Widget, showDialog;

Future<T> mkShowChildDialog<T>({
  @required BuildContext context,
  @required Widget child,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) => child,
  );
}
