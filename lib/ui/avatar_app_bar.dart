import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/ui/circle_avatar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class AvatarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String tag;
  final String imageUrl;
  final Widget title;
  final Widget subtitle;
  final Color iconColor;
  final Color backgroundColor;
  final double elevation;
  final bool useAlt;
  final List<Widget> actions;

  AvatarAppBar({
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

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    void onTapGoBack() {
      Navigator.pop(context);
    }

    Widget appBarLeading = new FlatButton(
      padding: EdgeInsets.fromLTRB(8.0, 8.0, 16.0, 8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Icon(
            Icons.arrow_back,
            color: iconColor ?? theme.appBarColor,
          ),
          new SizedBox(width: 4.0),
          new Hero(
            tag: tag,
            child: circleAvatar(
              imageUrl: imageUrl,
            ),
          ),
        ],
      ),
      onPressed: onTapGoBack,
    );

    List<Widget> titles = <Widget>[];

    if (title != null) {
      titles.add(title);
    }

    if (subtitle != null) {
      titles.addAll([SizedBox(height: 2.0), subtitle]);
      // new Text.rich(
      //   new TextSpan(
      //     children: [
      //       new TextSpan(
      //         text: widget.contact.pending.toString(),
      //         style: new TextStyle(fontWeight: FontWeight.w600),
      //       ),
      //       new TextSpan(
      //         text: " pending wear-ables",
      //       ),
      //     ],
      //   ),
      //   maxLines: 1,
      //   overflow: TextOverflow.ellipsis,
      //   style: new TextStyle(
      //     fontSize: 13.0,
      //     color: Colors.white,
      //   ),
      // ),
    }

    List<Widget> children = <Widget>[
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

    return Material(
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
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(kToolbarHeight);
}
