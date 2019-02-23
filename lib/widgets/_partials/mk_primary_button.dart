import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkPrimaryButton extends StatelessWidget {
  const MkPrimaryButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color = Colors.white,
    this.backgroundColor = MkColors.accent,
    this.padding,
    this.shape,
    this.useSafeArea = false,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Color color;
  final Color backgroundColor;
  final ShapeBorder shape;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final num _safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final _padding = EdgeInsets.only(
      top: padding?.top ?? 16.0,
      bottom: (padding?.bottom ?? 16.0) + (useSafeArea ? _safeAreaBottom : 0.0),
      left: padding?.left ?? 0.0,
      right: padding?.right ?? 0.0,
    );
    final _height =
        useSafeArea ? kButtonHeight + _safeAreaBottom : kButtonHeight;

    return Container(
      height: _height ?? kButtonHeight,
      constraints: BoxConstraints(
        minWidth: kButtonMinWidth,
      ),
      color: Colors.black,
      child: FlatButton(
        color: backgroundColor,
        padding: _padding,
        shape: shape ?? const StadiumBorder(),
        child: DefaultTextStyle(
          style: MkTheme.of(context).button.copyWith(color: color),
          child: child,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
