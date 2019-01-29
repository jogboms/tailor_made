import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_style.dart';

class FullButton extends StatelessWidget {
  const FullButton({
    Key key,
    @required this.onPressed,
    @required this.child,
    this.shape,
  }) : super(key: key);

  final Widget child;
  final VoidCallback onPressed;
  final ShapeBorder shape;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: onPressed != null ? 2.0 : 0.5,
      color: kAccentColor.withOpacity(onPressed != null ? 1.0 : .3),
      shape: shape ?? StadiumBorder(),
      child: InkWell(
        onTap: onPressed,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}
