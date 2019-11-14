import 'package:flutter/material.dart';
import 'package:injector/injector.dart';
import 'package:tailor_made/coordinator/coordinator_base.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/screens/jobs/job.dart';
import 'package:tailor_made/screens/jobs/jobs.dart';
import 'package:tailor_made/screens/jobs/jobs_create.dart';
import 'package:tailor_made/wrappers/mk_navigate.dart';

@immutable
class JobsCoordinator extends CoordinatorBase {
  const JobsCoordinator(GlobalKey<NavigatorState> navigatorKey) : super(navigatorKey);

  static JobsCoordinator di() => Injector.appInstance.getDependency<JobsCoordinator>();

  void toJob(JobModel job, {bool replace = false}) {
    replace
        ? navigator?.pushReplacement<dynamic, dynamic>(MkNavigate.slideIn(JobPage(job: job)))
        : navigator?.push<void>(MkNavigate.slideIn(JobPage(job: job)));
  }

  void toJobs() {
    navigator?.push<void>(MkNavigate.slideIn(const JobsPage()));
  }

  void toCreateJob(List<ContactModel> contacts, [ContactModel contact]) {
    navigator?.push<void>(MkNavigate.slideIn(JobsCreatePage(contacts: contacts, contact: contact)));
  }
}
