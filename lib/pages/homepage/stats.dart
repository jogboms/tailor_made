import 'package:flutter/material.dart';

class StatsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: new Row(
              children: <Widget>[
                new Align(
                  child: new Padding(
                    child: new Text("43", style: new TextStyle(fontSize: 20.0)),
                    padding: EdgeInsets.only(right: 10.0),
                  ),
                  alignment: Alignment.center,
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "Created",
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
                    ),
                    new Text(
                      "Projects",
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            color: Colors.grey.shade300,
            width: 1.0,
            height: 40.0,
            margin: EdgeInsets.only(left: 30.0, right: 30.0),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                new Align(
                  child: new Padding(
                    child: new Text("62", style: new TextStyle(fontSize: 20.0)),
                    padding: EdgeInsets.only(right: 10.0),
                  ),
                  alignment: Alignment.centerRight,
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      "Completed",
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
                    ),
                    new Text(
                      "Projects",
                      style: new TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
