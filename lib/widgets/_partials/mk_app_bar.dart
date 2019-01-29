import 'package:flutter/material.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';

class MkAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MkAppBar({
    Key key,
    @required this.title,
    this.actions,
    this.leading,
    this.useLeading = true,
    this.elevation = 1.0,
    this.bottom,
    this.brightness,
    this.centerTitle = false,
  }) : super(key: key);

  final Widget title;
  final Widget leading;
  final List<Widget> actions;
  final double elevation;
  final bool useLeading;
  final PreferredSizeWidget bottom;
  final Brightness brightness;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    final _style = MkTheme.of(context).appBarTitle;

    return AppBar(
      brightness: brightness ?? Brightness.light,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: useLeading,
      leading: useLeading ? leading ?? MkBackButton(color: _style.color) : null,
      title: DefaultTextStyle(
        child: title,
        style: _style,
      ),
      elevation: elevation,
      centerTitle: false,
      actions: actions,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom != null ? bottom.preferredSize.height : 0),
      );
}
