import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({
    super.key,
    this.color,
    this.size,
  });

  final Color? color;
  final double? size;

  @override
  Widget build(BuildContext context) {
    final double size = this.size ?? 32.0;
    return SizedBox.square(
      dimension: size,
      child: SpinKitFadingCube(
        size: size,
        itemBuilder: (_, int i) {
          if (color != null) {
            return _box(color);
          }
          return _box(Colors.black12);
        },
      ),
    );
  }

  Widget _box(Color? color) {
    return DecoratedBox(
      decoration: BoxDecoration(color: color),
    );
  }
}
