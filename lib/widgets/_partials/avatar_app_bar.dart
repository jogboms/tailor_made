import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    final MkTheme theme = MkTheme.of(context);

    void onTapGoBack() {
      Navigator.pop(context);
    }

    final Widget appBarLeading = FlatButton(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(
            Icons.arrow_back,
            color: iconColor ?? theme.appBarTitle.color,
          ),
          SizedBox(width: 4.0),
          Hero(
            tag: tag,
            child: MkCircleAvatar(
              imageUrl: imageUrl,
            ),
          ),
        ],
      ),
      onPressed: onTapGoBack,
    );

    final List<Widget> titles = <Widget>[];

    if (title != null) {
      titles.add(title);
    }

    if (subtitle != null) {
      titles.addAll([SizedBox(height: 2.0), subtitle]);
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
      appBarLeading,
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

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
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
