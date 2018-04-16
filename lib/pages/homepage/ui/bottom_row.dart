import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/payments/payments.dart';
import 'package:tailor_made/pages/contacts/contacts_create.dart';
import 'package:tailor_made/pages/projects/projects_create.dart';
import 'package:tailor_made/pages/payments/payments_create.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

enum CreateOptions {
  clients,
  projects,
  payments,
}

class BottomRowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

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
                child: TMListTile(
                  color: Colors.orangeAccent,
                  icon: Icons.supervisor_account,
                  title: "Clients",
                ),
              ),
              new SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, CreateOptions.projects);
                },
                child: TMListTile(
                  color: Colors.greenAccent.shade400,
                  icon: Icons.attach_money,
                  title: "Projects",
                ),
              ),
              new SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, CreateOptions.payments);
                },
                child: TMListTile(
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
            TMNavigate(context, ContactsCreatePage());
            break;
          }
        case CreateOptions.projects:
          {
            TMNavigate(context, ProjectsCreatePage());
            break;
          }
        case CreateOptions.payments:
          {
            TMNavigate(context, PaymentsCreatePage());
            break;
          }
      }
    }

    void onTapPayments() {
      TMNavigate(context, PaymentsPage());
    }

    return new Container(
      height: 120.0,
      decoration: new BoxDecoration(
        border: new Border(bottom: TMBorderSide()),
      ),
      child: new Row(
        children: <Widget>[
          new Expanded(
            child: new Container(
              decoration: new BoxDecoration(
                border: new Border(
                  right: TMBorderSide(),
                ),
              ),
              child: TMGridTile(
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
                    color: theme.textMutedColor,
                  ),
                  new Text(
                    "CREATE",
                    style: new TextStyle(
                      color: theme.textMutedColor,
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
