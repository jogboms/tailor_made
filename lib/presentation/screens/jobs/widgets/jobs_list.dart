import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/utils.dart';
import 'package:tailor_made/presentation/widgets.dart';

import 'job_list_item.dart';

class JobList extends StatelessWidget {
  const JobList({super.key, required this.jobs});

  final List<JobModel> jobs;

  @override
  Widget build(BuildContext context) {
    if (jobs.isEmpty) {
      return const SliverFillRemaining(child: EmptyResultView(message: 'No jobs available'));
    }

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 96.0),
      sliver: SliverList(
        delegate: AppSliverSeparatorBuilderDelegate(
          childCount: jobs.length,
          builder: (_, int index) => JobListItem(job: jobs[index]),
          separatorBuilder: (_, __) => const Divider(height: 0),
        ),
      ),
    );
  }
}
