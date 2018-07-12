import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/pages/contacts/contacts_create.dart';
import 'package:tailor_made/pages/homepage/ui/bottom_row.dart';
import 'package:tailor_made/pages/homepage/ui/header.dart';
import 'package:tailor_made/pages/homepage/ui/helpers.dart';
import 'package:tailor_made/pages/homepage/ui/stats.dart';
import 'package:tailor_made/pages/homepage/ui/top_row.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/contacts.dart';
import 'package:tailor_made/services/cloudstore.dart';
import 'package:tailor_made/ui/tm_loading_spinner.dart';
import 'package:tailor_made/utils/tm_colors.dart';
import 'package:tailor_made/utils/tm_images.dart';
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
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: Colors.transparent,
      //   // backgroundColor: theme.scaffoldColor,
      //   brightness: Brightness.light,
      //   // actions: <Widget>[
      //   //   new IconButton(
      //   //     icon: new Icon(
      //   //       Icons.person,
      //   //       color: theme.appBarColor,
      //   //     ),
      //   //     onPressed: () => TMNavigate(context, AccountsPage()),
      //   //   )
      //   // ],
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Opacity(
            opacity: .5,
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: TMImages.pattern,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          StreamBuilder(
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
                    new StoreConnector<ReduxState, ContactsViewModel>(
                      converter: (store) => ContactsViewModel(store),
                      onInit: (store) => store.dispatch(new InitDataEvents()),
                      onDispose: (store) => store.dispatch(new DisposeDataEvents()),
                      builder: (BuildContext context, ContactsViewModel vm) {
                        return new FlatButton(
                          shape: RoundedRectangleBorder(),
                          padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                          color: kAccentColor,
                          child: ScaleTransition(
                            scale: new Tween(begin: 0.95, end: 1.025).animate(controller),
                            alignment: FractionalOffset.center,
                            child: new Text(
                              "TAP TO CREATE",
                              style: ralewayBold(14.0, TMColors.white).copyWith(letterSpacing: 1.25),
                            ),
                          ),
                          onPressed: onTapCreate(vm.contacts),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
