import 'dart:async' show Future;

import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_child_dialog.dart';
import 'package:tailor_made/utils/tm_theme.dart';

Future<String> showEditDialog({
  @required BuildContext context,
  @required List<Widget> children,
  @required String title,
  @required VoidCallback onDone,
  @required VoidCallback onCancel,
}) {
  return showChildDialog<String>(
    context: context,
    child: new MeasureEditDialog(
      title: title,
      children: children,
      onDone: onDone,
      onCancel: onCancel,
    ),
  );
}

class MeasureEditDialog extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final VoidCallback onDone;
  final VoidCallback onCancel;

  const MeasureEditDialog({
    Key key,
    @required this.title,
    @required this.children,
    @required this.onDone,
    @required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: FractionalOffset(0.0, 0.25),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Material(
          borderRadius: BorderRadius.circular(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 16.0),
              Center(
                child: Text(title, style: ralewayLight(12.0)),
              ),
              SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 16.0,
                ),
                child: Theme(
                  data: ThemeData(
                    hintColor: kHintColor,
                    primaryColor: kPrimaryColor,
                  ),
                  child: Column(
                    children: children,
                  ),
                ),
              ),
              SizedBox(height: 4.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlatButton(
                    onPressed: onCancel,
                    child: Text("CANCEL", style: TextStyle(color: Colors.grey)),
                  ),
                  FlatButton(
                    onPressed: onDone,
                    child: Text("DONE"),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ),
      ),
    );
  }
}
