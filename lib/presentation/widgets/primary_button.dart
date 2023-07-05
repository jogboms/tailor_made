import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color,
    this.backgroundColor,
    this.padding,
    this.shape,
    this.useSafeArea = false,
  });

  final Widget child;
  final VoidCallback onPressed;
  final EdgeInsets? padding;
  final Color? color;
  final Color? backgroundColor;
  final ShapeBorder? shape;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final EdgeInsets defaultPadding = ButtonTheme.of(context).padding.resolve(null);
    final double safeAreaBottom = MediaQuery.paddingOf(context).bottom;
    final EdgeInsets localPadding = EdgeInsets.only(
      top: padding?.top ?? 16.0,
      bottom: (padding?.bottom ?? 16.0) + (useSafeArea ? safeAreaBottom : 0.0),
      left: padding?.left ?? defaultPadding.left,
      right: padding?.right ?? defaultPadding.right,
    );

    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: backgroundColor ?? colorScheme.secondary,
        padding: localPadding,
        foregroundColor: color ?? colorScheme.onSecondary,
        shape: shape as OutlinedBorder? ?? const StadiumBorder(),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
