import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_scale_util.dart';

class SnackBarProvider {
  SnackBarProvider.of(BuildContext context) : state = ScaffoldMessenger.of(context);

  SnackBarProvider.ofKey(GlobalKey<ScaffoldMessengerState> key) : state = key.currentState;

  final ScaffoldMessengerState? state;

  void success(String value, {Duration? duration}) {
    hide();
    show(
      value,
      leading: const Icon(Icons.check, color: Colors.white, size: 24),
      backgroundColor: MkColors.success,
    );
  }

  void info(String value, {Duration? duration}) {
    hide();
    show(
      value,
      leading: const Icon(Icons.info, color: MkColors.primary, size: 24),
      backgroundColor: Colors.white,
      color: Colors.black,
    );
  }

  void error(String value, {Duration? duration}) {
    hide();
    show(
      value,
      leading: const Icon(Icons.cancel, color: Colors.white, size: 24),
      backgroundColor: MkColors.danger,
    );
  }

  void show(
    String value, {
    Widget? leading,
    Duration? duration,
    Color backgroundColor = kAccentColor,
    Color color = Colors.white,
  }) {
    hide();
    state?.showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Row(
          children: <Widget>[
            if (leading != null) ...<Widget>[leading, SizedBox(width: sx(16))],
            Expanded(child: Text(value, style: mkFontMedium(14.0, color))),
          ],
        ),
        duration: duration ?? const Duration(seconds: 5),
      ),
    );
  }

  void hide() => state?.hideCurrentSnackBar();

  void loading({Widget? content, Color? backgroundColor, Color? color}) {
    hide();
    state?.showSnackBar(_LoadingSnackBar(content: content, backgroundColor: backgroundColor, color: color));
  }
}

abstract class SnackBarProviderMixin {
  GlobalKey<ScaffoldMessengerState> get scaffoldKey;

  void showInSnackBar(String value, [Duration? duration]) =>
      SnackBarProvider.ofKey(scaffoldKey).show(value, duration: duration);

  void closeLoadingSnackBar() => SnackBarProvider.ofKey(scaffoldKey).hide();

  void showLoadingSnackBar([Widget? content]) => SnackBarProvider.ofKey(scaffoldKey).loading(content: content);
}

class _LoadingSnackBar extends SnackBar {
  _LoadingSnackBar({Widget? content, Color? backgroundColor, Color? color})
      : super(
          backgroundColor: content == null ? Colors.white : (backgroundColor ?? kPrimaryColor),
          content: _RowBar(content: content, color: color),
          duration: const Duration(days: 1),
        );
}

class _RowBar extends StatelessWidget {
  const _RowBar({this.content, this.color});

  final Widget? content;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: content == null ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: <Widget>[
        SizedBox.fromSize(
          size: const Size(48.0, 24.0),
          child: SpinKitThreeBounce(color: content == null ? (color ?? kPrimaryColor) : Colors.white, size: 24.0),
        ),
        SizedBox(width: content == null ? 0.0 : 16.0),
        if (content != null)
          Expanded(
            child: DefaultTextStyle(style: mkFontColor(Colors.white), child: content!),
          ),
      ],
    );
  }
}
