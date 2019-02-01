import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_linear_gradient.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_touchable_opacity.dart';

class MkGradientButton extends StatelessWidget {
  const MkGradientButton({
    Key key,
    @required this.child,
    @required this.onPressed,
    this.color = Colors.white,
    this.style,
    this.enabled = true,
    this.height,
    this.padding,
    this.borderRadius,
    this.elevation = 0.0,
    this.useSafeArea = false,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets padding;
  final double elevation;
  final TextStyle style;
  final Color color;
  final bool enabled;
  final bool useSafeArea;
  final double borderRadius;
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

    return Opacity(
      opacity: enabled ? 1.0 : .6,
      child: Container(
        height: _height ?? kButtonHeight,
        constraints: BoxConstraints(
          minWidth: height ?? kButtonMinWidth,
        ),
        decoration: BoxDecoration(
          gradient: mkLinearGradient(),
          borderRadius: borderRadius != null
              ? BorderRadius.circular(borderRadius)
              : kBorderRadius,
          boxShadow: [
            BoxShadow(
              offset: Offset(0.0, elevation),
              blurRadius: elevation,
              color: Colors.black26,
            ),
          ],
        ),
        child: SizedBox.expand(
          child: MkTouchableOpacity(
            padding: _padding,
            child: DefaultTextStyle(
              style: style ?? MkTheme.of(context).button.copyWith(color: color),
              child: child,
            ),
            onPressed: enabled ? onPressed : null,
          ),
        ),
      ),
    );
  }
}
