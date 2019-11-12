import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/cloud_storage.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/services/jobs/jobs.dart';

class JobsImpl extends Jobs {
  @override
  Stream<List<JobModel>> fetchAll() {
    return CloudDb.jobs.snapshots().map(
        (snapshot) => snapshot.documents.map((item) => JobModel.fromDoc(Snapshot.fromDocumentSnapshot(item))).toList());
  }

  @override
  StorageReference createFile(File file) {
    return CloudStorage.createReferenceImage()..putFile(file);
  }

  @override
  Stream<JobModel> update(JobModel job) {
    final ref = CloudDb.jobsRef.document(job.id);
    ref.setData(job.toMap()).then((r) {});
    return ref.snapshots().map((doc) => JobModel.fromDoc(Snapshot.fromDocumentSnapshot(doc)));
  }
}
