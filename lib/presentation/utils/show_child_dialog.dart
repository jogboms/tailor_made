import 'dart:async' show Future;

import 'package:flutter/material.dart' show BuildContext, Widget, showDialog;

Future<T?> showChildDialog<T>({
  required BuildContext context,
  required Widget child,
  bool barrierDismissible = true,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (BuildContext context) => child,
  );
}
