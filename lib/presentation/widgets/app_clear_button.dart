import 'package:flutter/cupertino.dart';
import 'package:tailor_made/presentation/theme.dart';

class AppClearButton extends StatelessWidget {
  const AppClearButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.color = AppColors.primary,
    this.backgroundColor,
    this.borderRadius,
    this.padding,
    this.height,
    this.useSafeArea = false,
  });

  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final Color color;
  final Color? backgroundColor;
  final bool useSafeArea;
  final BorderRadius? borderRadius;
  final double? height;

  @override
  Widget build(BuildContext context) {
    final num safeAreaBottom = MediaQuery.of(context).padding.bottom;
    final EdgeInsets localPadding = EdgeInsets.only(
      top: padding?.top ?? 16.0,
      bottom: (padding?.bottom ?? 16.0) + (useSafeArea ? safeAreaBottom : 0.0),
      left: padding?.left ?? 0.0,
      right: padding?.right ?? 0.0,
    );
    final double height = (this.height ?? kButtonHeight) + (useSafeArea ? safeAreaBottom : 0);

    return CupertinoButton(
      padding: localPadding,
      minSize: height,
      color: backgroundColor,
      borderRadius: borderRadius ?? BorderRadius.zero,
      onPressed: onPressed,
      child: DefaultTextStyle(style: ThemeProvider.of(context)!.button.copyWith(color: color), child: child),
    );
  }
}
