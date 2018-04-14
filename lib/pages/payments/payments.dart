import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';

class PaymentsPage extends StatefulWidget {
  @override
  _PaymentsPageState createState() => new _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        context,
        title: "Payments",
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[],
      ),
    );
  }
}
