import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/services/jobs.dart';

class JobsMockImpl extends Jobs {
  @override
  Stream<List<JobModel>> fetchAll() async* {
    // TODO
    yield null;
  }

  @override
  StorageReference createFile(File file) {
    // TODO
    return null;
  }

  @override
  Stream<JobModel> update(JobModel job) async* {
    // TODO
    yield null;
  }
}
