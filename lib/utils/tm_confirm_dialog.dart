import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_child_dialog.dart';

Future<bool> confirmDialog({
  @required BuildContext context,
  @required Widget content,
  Widget title,
}) =>
    showChildDialog(
      context: context,
      child: new AlertDialog(
        title: title,
        content: content,
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("CANCEL"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text("OK"),
          ),
        ],
      ),
    );
