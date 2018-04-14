import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';

class ProjectsCreatePage extends StatefulWidget {
  @override
  _ProjectsCreatePageState createState() => new _ProjectsCreatePageState();
}

class _ProjectsCreatePageState extends State<ProjectsCreatePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      //   backgroundColor: Colors.grey.shade100,
      appBar: appBar(
        context,
        title: "Create Projects",
      ),
      body: Container(),
    );
  }
}
