import 'package:flutter/material.dart';
import 'package:tailor_made/pages/homepage/ui/bottom_row.dart';
import 'package:tailor_made/pages/homepage/ui/header.dart';
import 'package:tailor_made/pages/homepage/ui/stats.dart';
import 'package:tailor_made/pages/homepage/ui/top_row.dart';
import 'package:tailor_made/pages/accounts/accounts.dart';
import 'package:tailor_made/utils/tm_navigate.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.person,
              color: Colors.grey.shade800,
            ),
            onPressed: () => TMNavigate.ios(context, AccountsPage()),
          )
        ],
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          HeaderWidget(),
          StatsWidget(),
          TopRowWidget(),
          BottomRowWidget(),
        ],
      ),
    );
  }
}
