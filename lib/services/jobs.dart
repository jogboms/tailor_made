import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/firebase/cloud_db.dart';
import 'package:tailor_made/firebase/cloud_storage.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/job.dart';

class Jobs {
  static Stream<List<JobModel>> fetchAll() {
    return CloudDb.jobs.snapshots().map(
      (snapshot) {
        return snapshot.documents
            .map((item) => JobModel.fromDoc(Snapshot.fromFire(item)))
            .toList();
      },
    );
  }

  static StorageReference createFile(File file) {
    return CloudStorage.createReferenceImage()..putFile(file);
  }

  static Stream<JobModel> update(JobModel job) {
    final ref = CloudDb.jobsRef.document(job.id);
    ref.setData(job.toMap()).then((r) {});
    return ref.snapshots().map<JobModel>(
          (doc) => JobModel.fromDoc(Snapshot.fromFire(doc)),
        );
  }
}
