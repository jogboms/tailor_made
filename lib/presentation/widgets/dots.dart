import 'package:flutter/material.dart';

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
        shape: shape ??
            CircleBorder(
              side: Divider.createBorderSide(
                context,
                width: size / 6.5,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
      ),
    );
  }
}
