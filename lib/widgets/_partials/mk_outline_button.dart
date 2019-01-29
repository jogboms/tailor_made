import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkOutlineButton extends StatelessWidget {
  const MkOutlineButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color = MkColors.green,
    this.foregroundColor,
    this.padding,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Color color;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      padding: padding,
      child: DefaultTextStyle(
        style: MkTheme.of(context).button.copyWith(color: foregroundColor),
        child: child,
      ),
      onPressed: onPressed,
      borderSide: BorderSide(color: color, width: 2.0),
    );
  }
}
