import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/contacts_create.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/homepage/ui/bottom_row.dart';
import 'package:tailor_made/pages/homepage/ui/header.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/homepage/ui/stats.dart';
import 'package:tailor_made/pages/homepage/ui/top_row.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
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

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.signInAnonymously().then((r) {
      print(r);
    });
  }

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

    onTapCreate(List<ContactModel> contacts) {
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
            TMNavigate(context, JobsCreatePage(contacts: contacts));
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
        stream: new StreamZip([Cloudstore.jobs.snapshots(), Cloudstore.contacts.snapshots()]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: loadingSpinner(),
            );
          }

          final List<DocumentSnapshot> jobList = snapshot.data[0].documents;
          final jobs = jobList.map((item) => JobModel.fromDoc(item)).toList();

          final List<DocumentSnapshot> _list = snapshot.data[1].documents;
          var contactList = _list.where((doc) => doc.data.containsKey("fullname")).toList();
          final contacts = contactList.map((item) => ContactModel.fromDoc(item)).toList();

          return new SafeArea(
            top: false,
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                HeaderWidget(),
                StatsWidget(jobs: jobs),
                TopRowWidget(jobs: jobs, contacts: contacts),
                BottomRowWidget(jobs: jobs),
                new FlatButton(
                  padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                  child: new Text(
                    "CREATE",
                    style: ralewayMedium(14.0, theme.textMutedColor),
                  ),
                  onPressed: onTapCreate(contacts),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
