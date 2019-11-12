import 'package:flutter/material.dart';
import 'package:tailor_made/widgets/_partials/mk_app_bar.dart';

class AccountsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MkAppBar(
        title: Text("Account"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[],
      ),
    );
  }
}
