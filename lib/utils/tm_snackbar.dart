import 'package:flutter/material.dart';
import 'package:tailor_made/ui/loading_snackbar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

abstract class SnackBarProvider {
  GlobalKey<ScaffoldState> get scaffoldKey;

  void showInSnackBar(
    String value, [
    Duration duration = const Duration(milliseconds: 4000),
  ]) {
    scaffoldKey.currentState?.showSnackBar(
      new SnackBar(
        backgroundColor: kPrimaryColor,
        content: new Text(
          value,
          style: ralewayMedium(14.0, Colors.white),
        ),
        duration: duration,
      ),
    );
  }

  void closeLoadingSnackBar() {
    scaffoldKey.currentState?.hideCurrentSnackBar();
  }

  void showLoadingSnackBar([Widget content]) {
    scaffoldKey.currentState?.showSnackBar(
      new LoadingSnackBar(
        content: content,
      ),
    );
  }
}
