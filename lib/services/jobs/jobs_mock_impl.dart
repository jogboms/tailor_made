import 'dart:io';

import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/services/jobs/jobs.dart';

class JobsMockImpl extends Jobs {
  @override
  Stream<List<JobModel>> fetchAll() async* {
    // TODO
    yield null;
  }

  @override
  Storage createFile(File file) {
    // TODO
    return null;
  }

  @override
  Stream<JobModel> update(JobModel job) async* {
    // TODO
    yield null;
  }
}
