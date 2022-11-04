import 'package:flutter/material.dart';
import 'package:tailor_made/utils/ui/mk_status_bar.dart';
import 'package:tailor_made/widgets/_partials/mk_circle_avatar.dart';
import 'package:tailor_made/widgets/theme_provider.dart';

class AvatarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AvatarAppBar({
    super.key,
    required this.tag,
    required this.imageUrl,
    this.useAlt = false,
    this.title,
    this.backgroundColor = Colors.white,
    this.elevation = 0.0,
    this.actions,
    this.iconColor,
    this.subtitle,
  });

  final String tag;
  final String? imageUrl;
  final Widget? title;
  final Widget? subtitle;
  final Color? iconColor;
  final Color backgroundColor;
  final double elevation;
  final bool useAlt;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return MkStatusBar(
      child: Material(
        color: backgroundColor,
        elevation: elevation,
        child: SafeArea(
          child: Row(
            children: <Widget>[
              _Leading(iconColor: iconColor, tag: tag, imageUrl: imageUrl),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    if (title != null) title!,
                    if (subtitle != null) ...<Widget>[
                      const SizedBox(height: 2.0),
                      subtitle!,
                    ],
                  ],
                ),
              ),
              if (actions != null) ...actions!
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Leading extends StatelessWidget {
  const _Leading({required this.iconColor, required this.tag, required this.imageUrl});

  final Color? iconColor;
  final String tag;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      ),
      onPressed: () => Navigator.maybePop(context),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.arrow_back,
            color: iconColor ?? ThemeProvider.of(context)!.appBarTitle.color,
          ),
          const SizedBox(width: 4.0),
          Hero(tag: tag, child: MkCircleAvatar(imageUrl: imageUrl)),
        ],
      ),
    );
  }
}
