import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/jobs/jobs_create.dart';
import 'package:tailor_made/pages/jobs/jobs_list.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/ui/app_bar.dart';
import 'package:tailor_made/utils/tm_navigate.dart';
import 'package:tailor_made/utils/tm_theme.dart';

class JobsPage extends StatelessWidget {
  final List<JobModel> jobs;
  final List<ContactModel> contacts;

  JobsPage({
    Key key,
    @required this.jobs,
    @required this.contacts,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TMTheme theme = TMTheme.of(context);

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
            JobList(jobs: jobs),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () => TMNavigate(context, JobsCreatePage(contacts: contacts)),
      ),
    );
  }
}
