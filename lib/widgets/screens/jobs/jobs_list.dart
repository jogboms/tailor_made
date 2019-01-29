import 'dart:math' show max;

import 'package:flutter/material.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/jobs/job_list_item.dart';

class JobList extends StatelessWidget {
  const JobList({
    Key key,
    @required this.jobs,
  }) : super(key: key);

  final List<JobModel> jobs;

  @override
  Widget build(BuildContext context) {
    if (jobs == null || jobs.isEmpty) {
      return SliverFillRemaining(
        child: const EmptyResultView(message: "No jobs available"),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.only(bottom: 96.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            final int itemIndex = index ~/ 2;
            return (index == 0 || index.isEven)
                ? JobListItem(job: jobs[itemIndex])
                : const Divider();
          },
          childCount: max(0, jobs.length * 2 - 1),
        ),
      ),
    );
  }
}
