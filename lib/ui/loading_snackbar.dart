import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSnackBar extends SnackBar {
  LoadingSnackBar({Key key, Widget content})
      : super(
          key: key,
          content: Row(
            mainAxisAlignment: content == null
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              SizedBox.fromSize(
                size: Size.square(30.0),
                child: SpinKitFadingFour(
                  color: Colors.white,
                  size: 32.0,
                ),
              ),
              SizedBox(width: content == null ? 0.0 : 16.0),
              content ?? SizedBox(),
            ],
          ),
          duration: Duration(days: 1),
        );
}
