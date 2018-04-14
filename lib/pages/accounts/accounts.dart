import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';

class AccountsPage extends StatefulWidget {
  @override
  _AccountsPageState createState() => new _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        context,
        title: "Account",
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[],
      ),
    );
  }
}
