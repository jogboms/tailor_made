import 'package:flutter/material.dart';

import '../utils.dart';
import 'app_back_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.useLeading = true,
    this.elevation = 1.0,
    this.bottom,
    this.brightness,
    this.centerTitle = false,
  });

  static const PreferredSizeWidget empty = CustomAppBar(title: Text(''));

  final Widget title;
  final Widget? leading;
  final List<Widget>? actions;
  final double elevation;
  final bool useLeading;
  final PreferredSizeWidget? bottom;
  final Brightness? brightness;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: brightness?.systemOverlayStyle,
      automaticallyImplyLeading: useLeading,
      leading: useLeading ? leading ?? const AppBackButton() : null,
      title: title,
      elevation: elevation,
      centerTitle: false,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom != null ? bottom!.preferredSize.height : 0));
}
