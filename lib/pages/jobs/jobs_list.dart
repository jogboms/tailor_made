import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/job_list_item.dart';
import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';

class JobList extends StatelessWidget {
  final List<JobModel> jobs;

  JobList({
    Key key,
    this.jobs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return SliverFillRemaining(
        child: TMEmptyResult(message: "No jobs available"),
      );
    }

    return SliverList(
      delegate: new SliverChildListDelegate(
        jobs.map((job) => JobListItem(job: job)).toList(),
      ),
    );
  }
}
