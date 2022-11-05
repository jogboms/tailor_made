import 'dart:io';

import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/repository/models.dart';
import 'package:tailor_made/services/jobs/jobs.dart';

class JobsMockImpl extends Jobs {
  @override
  Stream<List<JobModel>> fetchAll(String? userId) async* {
    yield <JobModel>[JobModel((JobModelBuilder b) => b..userID = '1')];
  }

  @override
  Storage? createFile(File file, String userId) {
    return null;
  }

  @override
  Stream<JobModel> update(JobModel job, String userId) async* {}
}
