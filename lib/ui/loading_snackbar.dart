import 'package:flutter/material.dart';

class LoadingSnackBar extends SnackBar {
  LoadingSnackBar({Key key, Widget content})
      : super(
          key: key,
          content: Row(
            children: [
              new CircularProgressIndicator(),
              SizedBox(width: 16.0),
              content ?? new Text("Please wait...", style: TextStyle(color: Colors.white.withOpacity(.75))),
            ],
          ),
          duration: Duration(days: 1),
        );
}
