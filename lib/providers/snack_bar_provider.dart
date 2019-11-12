import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_screen_util.dart';

class SnackBarProvider {
  SnackBarProvider.of(BuildContext context)
      : assert(context != null),
        state = Scaffold.of(context);

  SnackBarProvider.ofKey(GlobalKey<ScaffoldState> key)
      : assert(key != null),
        state = key.currentState;

  final ScaffoldState state;

  void success(String value, {Duration duration}) {
    hide();
    assert(value != null);
    show(
      value,
      leading: Icon(Icons.check, color: Colors.white, size: sf(24)),
      backgroundColor: MkColors.success,
    );
  }

  void info(String value, {Duration duration}) {
    hide();
    assert(value != null);
    show(
      value,
      leading: Icon(Icons.info, color: MkColors.primary, size: sf(24)),
      backgroundColor: Colors.white,
      color: Colors.black,
    );
  }

  void error(String value, {Duration duration}) {
    hide();
    assert(value != null);
    show(
      value,
      leading: Icon(Icons.cancel, color: Colors.white, size: sf(24)),
      backgroundColor: MkColors.danger,
    );
  }

  void show(
    String value, {
    Widget leading,
    Duration duration,
    Color backgroundColor = kAccentColor,
    Color color = Colors.white,
  }) {
    hide();
    assert(value != null);
    state?.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Row(
          children: <Widget>[
            if (leading != null) ...[leading, SizedBox(width: sw(16))],
            Expanded(child: Text(value, style: mkFontMedium(14.0, color))),
          ],
        ),
        duration: duration ?? const Duration(seconds: 5),
      ),
    );
  }

  void hide() => state?.hideCurrentSnackBar();

  void loading({Widget content, Color backgroundColor, Color color}) {
    hide();
    state?.showSnackBar(_LoadingSnackBar(content: content, backgroundColor: backgroundColor, color: color));
  }
}

abstract class SnackBarProviderMixin {
  GlobalKey<ScaffoldState> get scaffoldKey;

  void showInSnackBar(String value, [Duration duration]) =>
      SnackBarProvider.ofKey(scaffoldKey).show(value, duration: duration);

  void closeLoadingSnackBar() => SnackBarProvider.ofKey(scaffoldKey).hide();

  void showLoadingSnackBar([Widget content]) => SnackBarProvider.ofKey(scaffoldKey).loading(content: content);
}

class _LoadingSnackBar extends SnackBar {
  _LoadingSnackBar({Key key, Widget content, Color backgroundColor, Color color})
      : super(
          key: key,
          backgroundColor: content == null ? Colors.white : (backgroundColor ?? kPrimaryColor),
          content: _RowBar(content: content, color: color),
          duration: const Duration(days: 1),
        );
}

class _RowBar extends StatelessWidget {
  const _RowBar({Key key, this.content, this.color}) : super(key: key);

  final Widget content;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: content == null ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        SizedBox.fromSize(
          size: const Size(48.0, 24.0),
          child: SpinKitThreeBounce(color: content == null ? (color ?? kPrimaryColor) : Colors.white, size: 24.0),
        ),
        SizedBox(width: content == null ? 0.0 : 16.0),
        if (content != null)
          Expanded(
            child: DefaultTextStyle(style: mkFontColor(Colors.white), child: content),
          ),
      ],
    );
  }
}
