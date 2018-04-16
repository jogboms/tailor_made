import 'package:flutter/material.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/contacts/contacts.dart';
import 'package:tailor_made/pages/projects/projects.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class TopRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void onTapProjects() {
      TMNavigate(context, ProjectsPage());
    }

    void onTapContacts() {
      TMNavigate(context, ContactsPage());
    }

    return new Container(
      height: 120.0,
      decoration: new BoxDecoration(
        border: new Border(bottom: TMBorderSide()),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: new BoxDecoration(
                border: new Border(right: TMBorderSide()),
              ),
              child: TMGridTile(
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
              child: TMGridTile(
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
