import 'package:flutter/material.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/utils/route_transitions.dart';

import '../screens/jobs/job.dart';
import '../screens/jobs/jobs.dart';
import '../screens/jobs/jobs_create.dart';
import 'coordinator_base.dart';

@immutable
class JobsCoordinator extends CoordinatorBase {
  const JobsCoordinator(super.navigatorKey);

  void toJob(JobEntity job, {bool replace = false}) {
    replace
        ? navigator?.pushReplacement<dynamic, dynamic>(RouteTransitions.slideIn(JobPage(job: job)))
        : navigator?.push<void>(RouteTransitions.slideIn(JobPage(job: job)));
  }

  void toJobs() {
    navigator?.push<void>(RouteTransitions.slideIn(const JobsPage()));
  }

  void toCreateJob(String userId, List<ContactModel> contacts, [ContactModel? contact]) {
    navigator
        ?.push<void>(RouteTransitions.slideIn(JobsCreatePage(userId: userId, contacts: contacts, contact: contact)));
  }
}
