import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:tailor_made/constants/mk_style.dart';

class MkLoadingSnackBar extends SnackBar {
  MkLoadingSnackBar({Key key, Widget content})
      : super(
          key: key,
          backgroundColor: content == null ? Colors.white : kPrimaryColor,
          content: _RowBar(content: content),
          duration: const Duration(days: 1),
        );
}

class _RowBar extends StatelessWidget {
  const _RowBar({
    Key key,
    this.content,
  }) : super(key: key);

  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          content == null ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        SizedBox.fromSize(
          size: const Size(48.0, 24.0),
          child: SpinKitThreeBounce(
            color: content == null ? kPrimaryColor : Colors.white,
            size: 24.0,
          ),
        ),
        SizedBox(width: content == null ? 0.0 : 16.0),
        content == null
            ? const SizedBox()
            : Expanded(
                child: DefaultTextStyle(
                  style: mkFontColor(Colors.white),
                  child: content,
                ),
              ),
      ],
    );
  }
}
