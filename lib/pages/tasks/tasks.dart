import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => new _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: appBar(
        context,
        title: "Tasks",
      ),
      body: new Container(),
    );
  }
}
