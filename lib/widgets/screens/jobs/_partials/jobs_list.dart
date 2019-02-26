import 'package:flutter/material.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/utils/mk_sliver_separator_builder_delegate.dart';
import 'package:tailor_made/widgets/_views/empty_result_view.dart';
import 'package:tailor_made/widgets/screens/jobs/_partials/job_list_item.dart';

class JobList extends StatelessWidget {
  const JobList({
    Key key,
    @required this.jobs,
  }) : super(key: key);

  final List<JobModel> jobs;

  @override
  Widget build(BuildContext context) {
    if (jobs == null || jobs.isEmpty) {
      return const SliverFillRemaining(
        child: const EmptyResultView(message: "No jobs available"),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 96.0),
      sliver: SliverList(
        delegate: MkSliverSeparatorBuilderDelegate(
          childCount: jobs.length,
          builder: (BuildContext context, int index) {
            return JobListItem(job: jobs[index]);
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(height: 0);
          },
        ),
      ),
    );
  }
}
