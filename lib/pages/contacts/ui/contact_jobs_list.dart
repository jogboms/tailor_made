import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class JobsListWidget extends StatelessWidget {
  @override
  build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    SliverChildBuilderDelegate delegate = new SliverChildBuilderDelegate(
      (BuildContext context, int index) {
        // return new Container(
        //   alignment: Alignment.center,
        //   color: Colors.lightBlue[100 * (index % 9)],
        //   child: new Text('list item $index'),
        // );
        onTapCheck() {
          print("onTapCheck");
        }

        onTapList() {
          print("onTapList");
        }

        return new Container(
          decoration: BoxDecoration(
            border: Border(bottom: TMBorderSide()),
          ),
          child: new InkWell(
            onTap: onTapList,
            child: new Container(
              // padding: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              // margin: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Container(
                    decoration: new BoxDecoration(
                      color: accentColor,
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    child: new Text.rich(
                      new TextSpan(
                        children: [
                          new TextSpan(text: "15\n", style: ralewayLight(30.0, Colors.white)),
                          new TextSpan(
                            text: "MAY",
                            style: ralewayLight(10.0, Colors.white).copyWith(
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  new SizedBox(width: 16.0),
                  new Expanded(
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("2 Italian Gowns", style: TextStyle(fontSize: 16.0, color: Colors.black)),
                        Text("₦3,000", style: TextStyle(color: textBaseColor)),
                      ],
                    ),
                  ),
                  new IconButton(
                    icon: new Icon(Icons.check_circle_outline, color: Colors.green),
                    onPressed: onTapCheck,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return SliverList(
      delegate: delegate,
    );
  }
}
