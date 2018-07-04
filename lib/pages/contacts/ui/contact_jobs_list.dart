import 'package:flutter/material.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/pages/jobs/jobs_list.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';

class JobsListWidget extends StatelessWidget {
  final ContactModel contact;
  final List<JobModel> jobs;

  JobsListWidget({
    Key key,
    @required this.contact,
    @required this.jobs,
  }) : super(key: key);

  @override
  build(BuildContext context) {
    if (jobs.isEmpty) {
      return SliverFillRemaining(
        child: TMEmptyResult(message: "No jobs available"),
      );
    }

    return JobList(jobs: jobs);
  }
}
