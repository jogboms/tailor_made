import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_colors.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class TMListTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onPressed;

  const TMListTile({
    Key key,
    this.icon,
    this.color,
    this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Row(
      children: <Widget>[
        circleIcon(icon: icon, color: color, small: true),
        textTile(theme, title: title, small: true),
      ],
    );
  }
}

class TMGridTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subTitle;
  final VoidCallback onPressed;

  const TMGridTile({
    this.icon,
    this.color,
    this.title,
    this.subTitle,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new FlatButton(
      padding: EdgeInsets.only(left: 20.0),
      splashColor: color.withOpacity(.25),
      child: new Row(
        children: <Widget>[
          circleIcon(icon: icon, color: color),
          textTile(theme, title: title, subTitle: subTitle),
        ],
      ),
      onPressed: onPressed,
    );
  }
}

Widget circleIcon({IconData icon, Color color: TMColors.accent, bool small: false}) {
  return new Align(
    child: new Padding(
      child: new CircleAvatar(
        backgroundColor: color,
        radius: small == true ? 14.0 : 20.0,
        child: new Icon(
          icon,
          size: small == true ? 14.0 : 20.0,
          color: Colors.white,
        ),
      ),
      padding: new EdgeInsets.only(right: small == true ? 8.0 : 10.0),
    ),
    alignment: Alignment.center,
  );
}

Widget textTile(TMTheme theme, {String title, String subTitle, bool small: false}) {
  return new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      new Text(
        title,
        style: new TextStyle(color: theme?.textColor, fontSize: small == true ? 15.0 : 16.0),
      ),
      subTitle != null
          ? new Text(
              subTitle,
              style: new TextStyle(color: theme?.textColor, fontSize: 12.0, fontWeight: FontWeight.w300),
            )
          : new Container(),
    ],
  );
}
