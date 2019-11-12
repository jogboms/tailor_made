import 'package:flutter/material.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/screens/jobs/_partials/job_list_item.dart';
import 'package:tailor_made/utils/ui/mk_sliver_separator_builder_delegate.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';

class JobList extends StatelessWidget {
  const JobList({Key key, @required this.jobs}) : super(key: key);

  final List<JobModel> jobs;

  @override
  Widget build(BuildContext context) {
    if (jobs == null || jobs.isEmpty) {
      return const SliverFillRemaining(child: EmptyResultView(message: "No jobs available"));
    }

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 96.0),
      sliver: SliverList(
        delegate: MkSliverSeparatorBuilderDelegate(
          childCount: jobs.length,
          builder: (_, int index) => JobListItem(job: jobs[index]),
          separatorBuilder: (_, __) => const Divider(height: 0),
        ),
      ),
    );
  }
}
