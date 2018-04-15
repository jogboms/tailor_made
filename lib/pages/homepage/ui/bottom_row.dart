import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/payments/payments.dart';
import 'package:tailor_made/pages/contacts/contacts_create.dart';
import 'package:tailor_made/pages/projects/projects_create.dart';
import 'package:tailor_made/pages/payments/payments_create.dart';
import 'package:tailor_made/utils/tm_navigate.dart';

enum CreateOptions {
  clients,
  projects,
  payments,
}

class BottomRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future onTapCreate() async {
      CreateOptions result = await showDialog<CreateOptions>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: const Text('Select action', style: const TextStyle(fontSize: 14.0)),
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, CreateOptions.clients);
                },
                child: listTile(
                  color: Colors.orangeAccent,
                  icon: Icons.supervisor_account,
                  title: "Clients",
                ),
              ),
              new SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, CreateOptions.projects);
                },
                child: listTile(
                  color: Colors.greenAccent.shade400,
                  icon: Icons.attach_money,
                  title: "Projects",
                ),
              ),
              new SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, CreateOptions.payments);
                },
                child: listTile(
                  color: Colors.redAccent,
                  icon: Icons.usb,
                  title: "Payments",
                ),
              ),
            ],
          );
        },
      );
      switch (result) {
        case CreateOptions.clients:
          {
            TMNavigate.ios(context, ContactsCreatePage());
            break;
          }
        case CreateOptions.projects:
          {
            TMNavigate.ios(context, ProjectsCreatePage());
            break;
          }
        case CreateOptions.payments:
          {
            TMNavigate.ios(context, PaymentsCreatePage());
            break;
          }
      }
    }

    void onTapPayments() {
      TMNavigate.ios(context, PaymentsPage());
    }

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
