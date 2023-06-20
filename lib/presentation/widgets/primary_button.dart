import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/theme.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = Colors.white,
    this.backgroundColor = AppColors.accent,
    this.padding,
    this.shape,
    this.useSafeArea = false,
  });

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets? padding;
  final Color color;
  final Color backgroundColor;
  final ShapeBorder? shape;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final num safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final EdgeInsets localPadding = EdgeInsets.only(
      top: padding?.top ?? 16.0,
      bottom: (padding?.bottom ?? 16.0) + (useSafeArea ? safeAreaBottom : 0.0),
      left: padding?.left ?? 0.0,
      right: padding?.right ?? 0.0,
    );
    final double height = useSafeArea ? kButtonHeight + safeAreaBottom : kButtonHeight;

    return Container(
      height: height,
      constraints: const BoxConstraints(minWidth: kButtonMinWidth),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: localPadding,
          shape: shape as OutlinedBorder? ?? const StadiumBorder(),
        ),
        onPressed: onPressed,
        child: DefaultTextStyle(style: ThemeProvider.of(context).button.copyWith(color: color), child: child),
      ),
    );
  }
}
