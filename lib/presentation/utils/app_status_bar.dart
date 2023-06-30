import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailor_made/presentation/utils.dart';

class AppStatusBar extends StatelessWidget {
  const AppStatusBar({super.key, this.brightness, required this.child});

  final Widget child;
  final Brightness? brightness;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (brightness ?? Theme.of(context).brightness).systemOverlayStyle,
      child: child,
    );
  }
}
