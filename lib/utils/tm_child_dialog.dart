import 'dart:async';

import 'package:flutter/material.dart';

Future<T> showChildDialog<T>({
  @required BuildContext context,
  @required Widget child,
}) {
  return showDialog<T>(
    context: context,
    builder: (BuildContext context) => child,
  );
}
