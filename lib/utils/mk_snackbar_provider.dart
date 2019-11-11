import 'package:flutter/material.dart';
import 'package:tailor_made/utils/mk_snackbar.dart';

abstract class MkSnackBarProvider {
  GlobalKey<ScaffoldState> get scaffoldKey;

  void showInSnackBar(String value, [Duration duration]) =>
      MkSnackBar.ofKey(scaffoldKey).show(value, duration: duration);

  void closeLoadingSnackBar() => MkSnackBar.ofKey(scaffoldKey).hide();

  void showLoadingSnackBar([Widget content]) => MkSnackBar.ofKey(scaffoldKey).loading(content: content);
}
