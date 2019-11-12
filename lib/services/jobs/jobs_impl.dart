import 'dart:io';

import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/cloud_storage.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/services/jobs/jobs.dart';

class JobsImpl extends Jobs {
  @override
  Stream<List<JobModel>> fetchAll() {
    return CloudDb.jobs
        .snapshots()
        .map((snapshot) => snapshot.documents.map((item) => JobModel.fromSnapshot(Snapshot(item))).toList());
  }

  @override
  Storage createFile(File file) {
    return Storage(CloudStorage.createReferenceImage()..putFile(file));
  }

  @override
  Stream<JobModel> update(JobModel job) {
    final ref = CloudDb.jobs.reference().document(job.id);
    ref.setData(job.toMap()).then((r) {});
    return ref.snapshots().map((doc) => JobModel.fromSnapshot(Snapshot(doc)));
  }
}
