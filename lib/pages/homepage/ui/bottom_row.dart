import 'package:flutter/material.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';

class BottomRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: borderSide,
        ),
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          new Expanded(
            child: new Container(
              // margin: EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.fromLTRB(20.0, 35.0, 25.0, 35.0),
              // width: 200.0,
              // height: 100.0,
              decoration: new BoxDecoration(
                border: new Border(
                  // bottom: borderSide,
                  right: borderSide,
                ),
              ),
              child: new Row(
                children: <Widget>[
                  circleIcon(icon: Icons.attach_money, color: Colors.redAccent),
                  textTile(title: "Payments", subTitle: "26 Received"),
                ],
              ),
            ),
          ),
          new Expanded(
            child: new Container(
              // margin: EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.fromLTRB(20.0, 35.0, 25.0, 35.0),
              // width: 200.0,
              // height: 100.0,
              child: new Center(
                child: new Padding(
                  child: new Column(
                    children: <Widget>[
                      new Icon(
                        Icons.add,
                        size: 38.0,
                        color: Colors.grey.shade300,
                      ),
                      new Text(
                        "CREATE",
                        style: new TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 10.0,
                          fontWeight: FontWeight.w300,
                        ),
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(0.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
