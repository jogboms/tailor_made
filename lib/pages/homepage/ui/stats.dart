import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget statsTile({int count, String title, String subTitle}) {
      return new Row(
        children: <Widget>[
          new Padding(
            child: new Text(count.toString(), style: new TextStyle(fontSize: 18.0)),
            padding: EdgeInsets.only(right: 10.0),
          ),
          new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Text(
                title,
                style: new TextStyle(fontSize: 13.0, fontWeight: FontWeight.w300),
              ),
              new Text(
                subTitle,
                style: new TextStyle(fontSize: 13.0, fontWeight: FontWeight.w300),
              ),
            ],
          )
        ],
      );
    }

    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            color: Colors.grey.shade300,
            style: BorderStyle.solid,
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: statsTile(count: 43, title: "Created", subTitle: "Projects"),
          ),
          Container(
            color: Colors.grey.shade300,
            width: 1.0,
            height: 40.0,
            margin: EdgeInsets.only(left: 30.0, right: 30.0),
          ),
          Expanded(
            child: statsTile(count: 62, title: "Completed", subTitle: "Projects"),
          ),
        ],
      ),
    );
  }
}
