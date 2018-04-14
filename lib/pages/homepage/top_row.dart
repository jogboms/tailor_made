import 'package:flutter/material.dart';
import 'package:tailor_made/pages/homepage/helpers.dart';
import 'package:tailor_made/pages/contacts.dart';
import 'package:tailor_made/utils/tm_colors.dart';

class TopRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        border: new Border(
          bottom: borderSide,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext context) => ContactsPage()),
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                padding: EdgeInsets.fromLTRB(20.0, 35.0, 25.0, 35.0),
                child: Row(
                  children: <Widget>[
                    circleIcon(icon: Icons.supervisor_account, color: Colors.orangeAccent),
                    textTile(title: "Clients", subTitle: "21 Contacts"),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: 5.0,
            decoration: new BoxDecoration(
            color: Colors.red,
              border: new Border(
                right: borderSide,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(20.0, 35.0, 25.0, 35.0),
              child: Row(
                children: <Widget>[
                  circleIcon(icon: Icons.usb),
                  textTile(title: "Projects", subTitle: "6 Pending"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
