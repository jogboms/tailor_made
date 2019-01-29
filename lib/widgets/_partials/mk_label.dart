import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkLabel extends StatelessWidget {
  const MkLabel({
    Key key,
    this.backgroundColor,
    this.color,
    this.title,
    this.radius = 16.0,
  }) : super(key: key);

  final Color backgroundColor;
  final Color color;
  final String title;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? MkColors.accent,
      borderRadius: BorderRadius.circular(radius),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.5),
        child: Text(
          title.toUpperCase(),
          style: MkTheme.of(context)
              .bodySemi
              .copyWith(color: color ?? Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
