import 'package:flutter/material.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class ProjectsCreatePage extends StatefulWidget {
  @override
  _ProjectsCreatePageState createState() => new _ProjectsCreatePageState();
}

class _ProjectsCreatePageState extends State<ProjectsCreatePage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Create Projects",
      ),
      body: Container(),
    );
  }
}
