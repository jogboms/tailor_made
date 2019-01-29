import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class MkBadge extends StatelessWidget {
  const MkBadge({
    Key key,
    this.backgroundColor,
    this.color,
    this.count = 0,
    this.radius = 4.0,
  }) : super(key: key);

  final Color backgroundColor;
  final Color color;
  final num count;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return count > 0
        ? Material(
            color: backgroundColor ?? MkColors.accent,
            borderRadius: BorderRadius.circular(radius),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: ConstrainedBox(
                child: Text(
                  count.toString(),
                  style: MkTheme.of(context)
                      .bodySemi
                      .copyWith(color: color ?? Colors.white),
                  textAlign: TextAlign.center,
                ),
                constraints: BoxConstraints(minWidth: 18.0, minHeight: 18.0),
              ),
            ),
          )
        : SizedBox();
  }
}
