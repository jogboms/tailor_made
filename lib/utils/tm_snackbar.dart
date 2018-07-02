import 'package:flutter/material.dart';
import 'package:tailor_made/ui/loading_snackbar.dart';

abstract class SnackBarProvider {
  GlobalKey<ScaffoldState> get scaffoldKey;

  void showInSnackBar(String value) {
    scaffoldKey.currentState?.showSnackBar(new SnackBar(content: new Text(value)));
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
