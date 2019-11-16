import 'dart:io';

import 'package:tailor_made/dependencies.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/jobs/jobs.dart';

class JobsImpl extends Jobs<FirebaseRepository> {
  @override
  Stream<List<JobModel>> fetchAll() {
    return repository.db
        .jobs(Dependencies.di().session.getUserId())
        .snapshots()
        .map((snapshot) => snapshot.documents.map((item) => JobModel.fromSnapshot(FireSnapshot(item))).toList());
  }

  @override
  FireStorage createFile(File file) {
    return FireStorage(repository.storage.createReferenceImage(Dependencies.di().session.getUserId())..putFile(file));
  }

  @override
  Stream<JobModel> update(JobModel job) {
    final ref = repository.db.jobs(Dependencies.di().session.getUserId()).reference().document(job.id);
    ref.setData(job.toMap()).then((r) {});
    return ref.snapshots().map((doc) => JobModel.fromSnapshot(FireSnapshot(doc)));
  }
}
