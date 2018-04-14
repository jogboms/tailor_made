import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => new _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar(
        context,
        title: "Projects",
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[],
      ),
    );
  }
}
