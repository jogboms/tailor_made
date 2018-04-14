import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 40.0),
        width: double.infinity,
        decoration: new BoxDecoration(
          border: new Border(
            bottom: new BorderSide(
              color: Colors.grey.shade300,
              style: BorderStyle.solid,
              width: 1.0,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Text(
              "Hello",
              style: new TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w100,
                letterSpacing: 2.5,
              ),
            ),
            new Text(
              "Mikun Sews",
              style: new TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w300,
                height: 1.05,
              ),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            new Text.rich(
              new TextSpan(
                children: [
                  new TextSpan(
                    text: "Sunday",
                    style: new TextStyle(fontWeight: FontWeight.w600),
                  ),
                  new TextSpan(text: ", 12"),
                  new TextSpan(
                    text: "nd",
                    style: new TextStyle(fontSize: 12.0),
                  ),
                  new TextSpan(text: " March"),
                ],
              ),
              style: new TextStyle(
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
