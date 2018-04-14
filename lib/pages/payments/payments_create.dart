import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';

class PaymentsCreatePage extends StatefulWidget {
  @override
  _PaymentsCreatePageState createState() => new _PaymentsCreatePageState();
}

class _PaymentsCreatePageState extends State<PaymentsCreatePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      //   backgroundColor: Colors.grey.shade100,
      appBar: appBar(
        context,
        title: "Create Payments",
      ),
      body: Container(),
    );
  }
}
