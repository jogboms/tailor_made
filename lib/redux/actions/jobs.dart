import 'package:tailor_made/pages/jobs/models/job.model.dart';
import 'package:tailor_made/redux/actions/main.dart';

class InitJobs extends ActionType {
  final String type = ReduxActions.initJobs;
  final List<JobModel> payload;

  InitJobs({this.payload});
}

class AddJob extends ActionType {
  final String type = ReduxActions.addJob;
  final JobModel payload;

  AddJob({this.payload});
}
