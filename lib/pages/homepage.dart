import 'package:flutter/material.dart';
import 'package:tailor_made/utils/tm_colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

BorderSide borderSide = BorderSide(
  color: Colors.grey.shade300,
  style: BorderStyle.solid,
  width: 1.0,
);

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Widget cardsWidgetRow1 = Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: borderSide,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
              padding: EdgeInsets.fromLTRB(20.0, 35.0, 25.0, 35.0),
              // width: 200.0,
              // height: 100.0,
              decoration: BoxDecoration(
                border: Border(
                  // bottom: borderSide,
                  right: borderSide,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Align(
                    child: Padding(
                      child: CircleAvatar(
                        backgroundColor: TMColors.accent,
                        radius: 20.0,
                        child: Icon(
                          Icons.supervisor_account,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      // padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    alignment: Alignment.center,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Clients",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "21 Contacts",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w300),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              // margin: EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.fromLTRB(20.0, 35.0, 25.0, 35.0),
              // width: 200.0,
              // height: 100.0,
              child: Row(
                children: <Widget>[
                  Align(
                    child: Padding(
                      child: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        radius: 20.0,
                        child: Icon(
                          Icons.usb,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      // padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    alignment: Alignment.center,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Projects",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "6 Pending",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w300),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );

    Widget cardsWidgetRow2 = Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: borderSide,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
              // margin: EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.fromLTRB(20.0, 35.0, 25.0, 35.0),
              // width: 200.0,
              // height: 100.0,
              decoration: BoxDecoration(
                border: Border(
                  // bottom: borderSide,
                  right: borderSide,
                ),
              ),
              child: Row(
                children: <Widget>[
                  Align(
                    child: Padding(
                      child: CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 20.0,
                        child: Icon(
                          Icons.attach_money,
                          size: 20.0,
                          color: Colors.white,
                        ),
                      ),
                      // padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      padding: EdgeInsets.only(right: 10.0),
                    ),
                    alignment: Alignment.center,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Payments",
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "26 Received",
                        style: TextStyle(
                            fontSize: 14.0, fontWeight: FontWeight.w300),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              // margin: EdgeInsets.only(top: 5.0),
              padding: EdgeInsets.fromLTRB(20.0, 35.0, 25.0, 35.0),
              // width: 200.0,
              // height: 100.0,
              child: Center(
                child: Padding(
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        size: 38.0,
                        color: Colors.grey.shade300,
                      ),
                      Text(
                        "CREATE",
                        style: TextStyle(
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

    Widget statsWidget = Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
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
            child: Row(
              children: <Widget>[
                Align(
                  child: Padding(
                    child: Text("43", style: TextStyle(fontSize: 20.0)),
                    padding: EdgeInsets.only(right: 10.0),
                  ),
                  alignment: Alignment.center,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Created",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "Projects",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w300),
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
                Align(
                  child: Padding(
                    child: Text("62", style: TextStyle(fontSize: 20.0)),
                    padding: EdgeInsets.only(right: 10.0),
                  ),
                  alignment: Alignment.centerRight,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Completed",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w300),
                    ),
                    Text(
                      "Projects",
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.w300),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );

    Widget headerWidget = Expanded(
      child: Container(
        padding: EdgeInsets.fromLTRB(20.0, 35.0, 20.0, 40.0),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
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
            Text(
              "Hello",
              style: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w100,
                letterSpacing: 2.5,
              ),
            ),
            Text(
              "Mikun Sews",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w300,
                height: 1.05,
              ),
              maxLines: 1,
              overflow: TextOverflow.fade,
              softWrap: false,
            ),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Sunday",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: ", 12"),
                  TextSpan(
                    text: "nd",
                    style: TextStyle(fontSize: 12.0),
                  ),
                  TextSpan(text: " March"),
                ],
              ),
              style: TextStyle(
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );

    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.person,
              size: 35.0,
              color: Colors.grey.shade800,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          headerWidget,
          statsWidget,
          cardsWidgetRow1,
          cardsWidgetRow2
        ],
      ),
    );
  }
}
