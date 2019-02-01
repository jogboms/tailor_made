import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/utils/mk_status_bar.dart';
import 'package:tailor_made/utils/mk_theme.dart';
import 'package:tailor_made/widgets/_partials/mk_circle_avatar.dart';

class AvatarAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AvatarAppBar({
    @required this.tag,
    @required this.imageUrl,
    this.useAlt = false,
    this.title,
    this.backgroundColor = Colors.white,
    this.elevation = 0.0,
    this.actions,
    this.iconColor,
    this.subtitle,
  });

  final String tag;
  final String imageUrl;
  final Widget title;
  final Widget subtitle;
  final Color iconColor;
  final Color backgroundColor;
  final double elevation;
  final bool useAlt;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final List<Widget> titles = <Widget>[];

    if (title != null) {
      titles.add(title);
    }

    if (subtitle != null) {
      titles.addAll(
        [
          const SizedBox(height: 2.0),
          subtitle,
        ],
      );
      // Text.rich(
      //   TextSpan(
      //     children: [
      //       TextSpan(
      //         text: widget.contact.pending.toString(),
      //         style: TextStyle(fontWeight: FontWeight.w600),
      //       ),
      //       TextSpan(
      //         text: " pending wear-ables",
      //       ),
      //     ],
      //   ),
      //   maxLines: 1,
      //   overflow: TextOverflow.ellipsis,
      //   style: TextStyle(
      //     fontSize: 13.0,
      //     color: Colors.white,
      //   ),
      // ),
    }

    final List<Widget> children = <Widget>[
      _Leading(
        iconColor: iconColor,
        tag: tag,
        imageUrl: imageUrl,
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: titles,
        ),
      ),
    ];

    if (actions != null) {
      children.addAll(actions);
    }

    return MkStatusBar(
      child: Material(
        color: backgroundColor,
        elevation: elevation,
        child: SafeArea(
          top: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _Leading extends StatelessWidget {
  const _Leading({
    Key key,
    @required this.iconColor,
    @required this.tag,
    @required this.imageUrl,
  }) : super(key: key);

  final Color iconColor;
  final String tag;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.arrow_back,
            color: iconColor ?? MkTheme.of(context).appBarTitle.color,
          ),
          const SizedBox(width: 4.0),
          Hero(
            tag: tag,
            child: MkCircleAvatar(
              imageUrl: imageUrl,
            ),
          ),
        ],
      ),
      onPressed: () => Navigator.maybePop(context),
    );
  }
}
