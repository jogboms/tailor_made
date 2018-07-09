import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/contacts_create.dart';
import 'package:tailor_made/pages/homepage/models/stats.model.dart';
import 'package:tailor_made/pages/homepage/ui/bottom_row.dart';
import 'package:tailor_made/pages/homepage/ui/header.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/homepage/ui/stats.dart';
import 'package:tailor_made/pages/homepage/ui/top_row.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_colors.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

enum CreateOptions {
  clients,
  jobs,
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(vsync: this, duration: Duration(milliseconds: 1200))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    onTapCreate() {
      return () async {
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
                    Navigator.pop(context, CreateOptions.jobs);
                  },
                  child: TMListTile(
                    color: Colors.greenAccent.shade400,
                    icon: Icons.attach_money,
                    title: "Job",
                  ),
                ),
              ],
            );
          },
        );
        switch (result) {
          case CreateOptions.clients:
            TMNavigate(context, ContactsCreatePage());
            break;
          case CreateOptions.jobs:
            TMNavigate(context, JobsCreatePage(contacts: []));
            break;
        }
      };
    }

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: theme.scaffoldColor,
        // actions: <Widget>[
        //   new IconButton(
        //     icon: new Icon(
        //       Icons.person,
        //       color: theme.appBarColor,
        //     ),
        //     onPressed: () => TMNavigate(context, AccountsPage()),
        //   )
        // ],
      ),
      body: StreamBuilder(
        stream: Cloudstore.stats.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingSpinner(),
            );
          }

          final DocumentSnapshot _data = snapshot.data;
          final stats = StatsModel.fromJson(_data.data);

          return new SafeArea(
            top: false,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                HeaderWidget(),
                StatsWidget(stats: stats),
                TopRowWidget(stats: stats),
                BottomRowWidget(stats: stats),
                new FlatButton(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  color: accentColor,
                  child: ScaleTransition(
                    scale: new Tween(begin: 1.0, end: 1.025).animate(controller),
                    alignment: FractionalOffset.center,
                    child: new Text(
                      "TAP TO CREATE",
                      // style: ralewayMedium(14.0, theme.textMutedColor),
                      style: ralewayMedium(14.0, TMColors.white).copyWith(letterSpacing: 1.25),
                    ),
                  ),
                  onPressed: onTapCreate(),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
