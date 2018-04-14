import 'package:flutter/material.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/contacts/contacts.dart';
import 'package:tailor_made/pages/projects/projects.dart';

class TopRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void onTapProjects() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => ProjectsPage()),
      );
    }

    void onTapContacts() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (BuildContext context) => ContactsPage()),
      );
    }

    return new Container(
      height: 120.0,
      decoration: new BoxDecoration(
        border: new Border(bottom: borderSide),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: new BoxDecoration(
                border: new Border(right: borderSide),
              ),
              child: gridTile(
                icon: Icons.supervisor_account,
                color: Colors.orangeAccent,
                title: "Clients",
                subTitle: "21 Contacts",
                onPressed: onTapContacts,
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: gridTile(
                icon: Icons.usb,
                color: Colors.greenAccent.shade400,
                title: "Projects",
                subTitle: "6 Pending",
                onPressed: onTapProjects,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
