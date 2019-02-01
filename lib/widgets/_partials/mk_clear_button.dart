import 'package:flutter/cupertino.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkClearButton extends StatelessWidget {
  const MkClearButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color = MkColors.primary,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.height,
    this.useSafeArea = false,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final Color color;
  final Color backgroundColor;
  final bool useSafeArea;
  final BorderRadius borderRadius;
  final double height;

  @override
  Widget build(BuildContext context) {
    final num _safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final _padding = EdgeInsets.only(
      top: padding?.top ?? 16.0,
      bottom: (padding?.bottom ?? 16.0) + (useSafeArea ? _safeAreaBottom : 0.0),
      left: padding?.left ?? 0.0,
      right: padding?.right ?? 0.0,
    );
    final _h = height ?? kButtonHeight;
    final _height = useSafeArea ? _h + _safeAreaBottom : _h;

    return CupertinoButton(
      padding: _padding,
      minSize: _height ?? kButtonHeight,
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: DefaultTextStyle(
        style: MkTheme.of(context).button.copyWith(color: color),
        child: child,
      ),
      onPressed: onPressed,
    );
  }
}
