import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_colors.dart';

BorderSide borderSide = new BorderSide(
  color: Colors.grey.shade300,
  style: BorderStyle.solid,
  width: 1.0,
);

Widget listTile({IconData icon, Color color, String title}) {
  return new Row(
    children: <Widget>[
      circleIcon(icon: icon, color: color, small: true),
      textTile(title: title, small: true),
    ],
  );
}

Widget gridTile({IconData icon, Color color, String title, String subTitle, VoidCallback onPressed}) {
  return FlatButton(
    padding: EdgeInsets.only(left: 20.0),
    splashColor: color.withOpacity(.25),
    child: new Row(
      children: <Widget>[
        circleIcon(icon: icon, color: color),
        textTile(title: title, subTitle: subTitle),
      ],
    ),
    onPressed: onPressed,
  );
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
      // padding: EdgeInsets.only(left: 2.5, right: 10.0),
      padding: new EdgeInsets.only(right: (small == true ? 8.0 : 10.0)),
    ),
    alignment: Alignment.center,
  );
}

Widget textTile({String title, String subTitle, bool small: false}) {
  return new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      new Text(
        title,
        style: new TextStyle(fontSize: small == true ? 14.0 : 18.0),
      ),
      subTitle != null
          ? new Text(
              subTitle,
              style: new TextStyle(fontSize: 12.0, fontWeight: FontWeight.w300),
            )
          : new Container(),
    ],
  );
}

// MaterialColor themeTextColor = Colors.grey;
// MaterialColor themeTextColor = TMColors.white;
// MaterialColor themeTextColor = Colors.teal;
// MaterialColor themeTextColor = Colors.blueGrey;
