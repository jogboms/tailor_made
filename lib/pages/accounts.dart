import 'package:flutter/material.dart';
import 'package:tailor_made/ui/back_button.dart';

class AccountsPage extends StatefulWidget {
  @override
  _AccountsPageState createState() => new _AccountsPageState();
}

class _AccountsPageState extends State<AccountsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // elevation: 0.0,
        leading: backButton(context),
        title: new Text(
          "Account",
          style: new TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.95,
          ),
        ),
        // centerTitle: true,
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[],
      ),
    );
  }
}
