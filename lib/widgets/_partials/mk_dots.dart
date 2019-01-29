import 'package:flutter/material.dart';

class MkDots extends StatelessWidget {
  const MkDots({
    Key key,
    @required this.color,
    this.size = 16.0,
    this.shape = const CircleBorder(),
  }) : super(key: key);

  final double size;
  final Color color;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: Size.square(size),
      child: Material(
        color: color,
        shape: shape,
      ),
    );
  }
}
