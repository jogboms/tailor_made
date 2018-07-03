import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_theme.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/pages/jobs/jobs_list.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';

class JobsPage extends StatefulWidget {
  @override
  _JobsPageState createState() => new _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);
    List<JobModel> list = List
        .generate(
          40,
          (int) => JobModel(),
        )
        .toList();

    return new Scaffold(
      backgroundColor: theme.scaffoldColor,
      appBar: appBar(
        context,
        title: "Jobs",
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: <Widget>[
            JobList(jobs: list),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => TMNavigate(context, JobsCreatePage()),
      ),
    );
  }
}
