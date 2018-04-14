import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';

class ContactsCreatePage extends StatefulWidget {
  @override
  _ContactsCreatePageState createState() => new _ContactsCreatePageState();
}

class _ContactsCreatePageState extends State<ContactsCreatePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      //   backgroundColor: Colors.grey.shade100,
      appBar: appBar(
        context,
        title: "Create Contacts",
      ),
      body: Container(),
    );
  }
}
