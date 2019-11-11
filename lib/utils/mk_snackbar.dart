import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/widgets/_partials/mk_loading_snackbar.dart';

class MkSnackBar {
  MkSnackBar.of(BuildContext context)
      : assert(context != null),
        state = Scaffold.of(context);

  MkSnackBar.ofKey(GlobalKey<ScaffoldState> key)
      : assert(key != null),
        state = key.currentState;

  final ScaffoldState state;

  void show(String value, {Duration duration}) {
    hide();
    assert(value != null);
    state?.showSnackBar(
      SnackBar(
        backgroundColor: kAccentColor,
        content: Text(value, style: mkFontMedium(14.0, Colors.white)),
        duration: duration ?? const Duration(seconds: 5),
      ),
    );
  }

  void hide() => state?.hideCurrentSnackBar();

  void loading({Widget content}) {
    hide();
    state?.showSnackBar(MkLoadingSnackBar(content: content));
  }
}
