import 'package:flutter/material.dart';
import 'package:tailor_made/pages/jobs/jobs_list.dart';
import 'package:tailor_made/pages/jobs/models/job_list.model.dart';

class JobsListWidget extends StatelessWidget {
  @override
  build(BuildContext context) {
    return JobList(
      lists: List
          .generate(
            40,
            (int) => JobListModel(),
          )
          .toList(),
    );
  }
}
