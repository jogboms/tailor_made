import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkRaisedButton extends StatelessWidget {
  const MkRaisedButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color = Colors.white,
    this.backgroundColor = MkColors.accent,
    this.padding,
    // this.shape,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Color color;
  final Color backgroundColor;
  // final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: backgroundColor,
      padding: padding,
      child: DefaultTextStyle(
        style: MkTheme.of(context).button.copyWith(color: color),
        child: child,
      ),
      onPressed: onPressed,
    );
  }
}
