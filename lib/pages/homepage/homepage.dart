import 'package:flutter/material.dart';
import 'package:tailor_made/pages/homepage/ui/bottom_row.dart';
import 'package:tailor_made/pages/homepage/ui/header.dart';
import 'package:tailor_made/pages/homepage/ui/stats.dart';
import 'package:tailor_made/pages/homepage/ui/top_row.dart';
import 'package:tailor_made/pages/accounts/accounts.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: theme.scaffoldColor,
        actions: <Widget>[
          new IconButton(
            icon: new Icon(
              Icons.person,
              color: theme.appBarColor,
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
