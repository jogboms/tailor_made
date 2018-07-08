import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSnackBar extends SnackBar {
  LoadingSnackBar({Key key, Widget content})
      : super(
          key: key,
          content: Row(
            children: [
              SpinKitFadingFour(
                color: Colors.white,
                width: 32.0,
                height: 32.0,
              ),
              SizedBox(width: 16.0),
              content ?? new Text("Please wait...", style: TextStyle(color: Colors.white.withOpacity(.75))),
            ],
          ),
          duration: Duration(days: 1),
        );
}
