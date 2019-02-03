import 'package:flutter/material.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_back_button.dart';

class MkPlainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MkPlainAppBar({
    Key key,
    this.leading,
    this.title,
    this.actions,
  }) : super(key: key);

  final String title;
  final List<Widget> actions;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      leading: leading ??
          const MkBackButton(
            color: Colors.white,
          ),
      title: title != null
          ? Text(
              title,
              style: MkTheme.of(context).appBarTitle.copyWith(
                    color: Colors.white,
                  ),
            )
          : null,
      actions: actions,
      centerTitle: false,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
