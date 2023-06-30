import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tailor_made/presentation/theme.dart';

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
    final TextStyle style = Theme.of(context).appBarTitle;

    return AppBar(
      systemOverlayStyle: brightness == Brightness.light ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: useLeading,
      leading: useLeading ? leading ?? AppBackButton(color: style.color) : null,
      title: DefaultTextStyle(style: style, child: title),
      elevation: elevation,
      centerTitle: false,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + (bottom != null ? bottom!.preferredSize.height : 0));
}
