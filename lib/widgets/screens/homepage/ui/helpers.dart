import 'package:flutter/material.dart';
import 'package:tailor_made/constants/mk_colors.dart';
import 'package:tailor_made/constants/mk_style.dart';
import 'package:tailor_made/utils/mk_theme.dart';

class TMListTile extends StatelessWidget {
  const TMListTile({
    Key key,
    this.icon,
    this.color,
    this.title,
    this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);
    return Row(
      children: <Widget>[
        circleIcon(icon: icon, color: color, small: true),
        textTile(theme, title: title, small: true),
      ],
    );
  }
}

class TMGridTile extends StatelessWidget {
  const TMGridTile({
    this.icon,
    this.color,
    this.title,
    this.subTitle,
    this.onPressed,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final MkTheme theme = MkTheme.of(context);
    return FlatButton(
      padding: EdgeInsets.only(left: 20.0),
      splashColor: color.withOpacity(.25),
      child: Row(
        children: <Widget>[
          circleIcon(icon: icon, color: color),
          textTile(theme, title: title, subTitle: subTitle),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

Widget circleIcon({
  IconData icon,
  Color color: MkColors.accent,
  bool small: false,
}) {
  return Align(
    child: Padding(
      child: CircleAvatar(
        backgroundColor: color,
        radius: small == true ? 14.0 : 20.0,
        child: Icon(
          icon,
          size: small == true ? 14.0 : 20.0,
          color: Colors.white,
        ),
      ),
      padding: EdgeInsets.only(right: small == true ? 8.0 : 10.0),
    ),
    alignment: Alignment.center,
  );
}

Widget textTile(MkTheme theme,
    {String title, String subTitle, bool small: false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(
        title,
        style: TextStyle(
          color: kTextBaseColor,
          fontSize: small == true ? 15.0 : 16.0,
        ),
      ),
      subTitle != null
          ? Text(
              subTitle,
              style: TextStyle(
                  color: kTextBaseColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w300),
            )
          : Container(),
    ],
  );
}
