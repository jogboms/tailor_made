import 'package:flutter/material.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';

class BottomRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void onTapCreate() {}
    void onTapPayments() {}

    return new Container(
      height: 120.0,
      decoration: new BoxDecoration(
        border: new Border(bottom: borderSide),
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              decoration: new BoxDecoration(
                border: new Border(
                  right: borderSide,
                ),
              ),
              child: gridTile(
                color: Colors.redAccent,
                icon: Icons.attach_money,
                title: "Payments",
                subTitle: "26 Received",
                onPressed: onTapPayments,
              ),
            ),
          ),
          new Expanded(
            child: new FlatButton(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: onTapCreate,
            ),
          ),
        ],
      ),
    );
  }
}
