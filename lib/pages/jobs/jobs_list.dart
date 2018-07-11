import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/job_list_item.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/ui/tm_empty_result.dart';

class JobList extends StatelessWidget {
  final List<JobModel> jobs;

  JobList({
    Key key,
    @required this.jobs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return SliverFillRemaining(
        child: TMEmptyResult(message: "No jobs available"),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.only(bottom: 96.0),
      sliver: SliverList(
        delegate: new SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final int itemIndex = index ~/ 2;
            return (index == 0 || index.isEven) ? JobListItem(job: jobs[itemIndex]) : new Divider();
          },
          childCount: max(0, jobs.length * 2 - 1),
        ),
      ),
    );
  }
}
