import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class PaymentsCreatePage extends StatefulWidget {
  @override
  _PaymentsCreatePageState createState() => new _PaymentsCreatePageState();
}

class _PaymentsCreatePageState extends State<PaymentsCreatePage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Create Payments",
      ),
      body: Container(),
    );
  }
}
