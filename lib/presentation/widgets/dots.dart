import 'package:flutter/material.dart';
import 'package:tailor_made/presentation/theme.dart';

class Dots extends StatelessWidget {
  const Dots({super.key, required this.color, this.size = 16.0, this.shape});

  final double size;
  final Color color;
  final ShapeBorder? shape;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(size),
      child: Material(
        color: color,
        shape: shape ?? const CircleBorder(side: AppBorderSide(width: 2.5, color: Colors.white)),
      ),
    );
  }
}
