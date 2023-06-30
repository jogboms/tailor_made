import 'package:flutter/material.dart';

import '../../../utils.dart';
import '../../../widgets.dart';

class AvatarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AvatarAppBar({
    super.key,
    required this.tag,
    required this.imageUrl,
    this.useAlt = false,
    this.title,
    this.elevation = 0.0,
    this.actions,
    this.subtitle,
    this.useSafeArea = false,
  });

  final String tag;
  final String? imageUrl;
  final Widget? title;
  final Widget? subtitle;
  final double elevation;
  final bool useAlt;
  final List<Widget>? actions;
  final bool useSafeArea;

  @override
  Widget build(BuildContext context) {
    return AppStatusBar(
      child: Material(
        type: MaterialType.transparency,
        elevation: elevation,
        child: SafeArea(
          top: useSafeArea,
          bottom: false,
          child: Row(
            children: <Widget>[
              _Leading(tag: tag, imageUrl: imageUrl),
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
  const _Leading({required this.tag, required this.imageUrl});

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
          const Icon(Icons.arrow_back),
          const SizedBox(width: 4.0),
          Hero(tag: tag, child: AppCircleAvatar(imageUrl: imageUrl)),
        ],
      ),
    );
  }
}
