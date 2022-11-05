import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class AppStatusBar extends StatelessWidget {
  const AppStatusBar({super.key, this.brightness = Brightness.dark, required this.child});

  final Widget child;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: brightness == Brightness.dark ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: child,
    );
  }
}
