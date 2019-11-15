import 'dart:io';

import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/jobs/jobs.dart';
import 'package:tailor_made/services/session.dart';

class JobsImpl extends Jobs<FirebaseRepository> {
  @override
  Stream<List<JobModel>> fetchAll() {
    return repository.db
        .jobs(Session.di().getUserId())
        .snapshots()
        .map((snapshot) => snapshot.documents.map((item) => JobModel.fromSnapshot(FireSnapshot(item))).toList());
  }

  @override
  FireStorage createFile(File file) {
    return FireStorage(repository.storage.createReferenceImage(Session.di().getUserId())..putFile(file));
  }

  @override
  Stream<JobModel> update(JobModel job) {
    final ref = repository.db.jobs(Session.di().getUserId()).reference().document(job.id);
    ref.setData(job.toMap()).then((r) {});
    return ref.snapshots().map((doc) => JobModel.fromSnapshot(FireSnapshot(doc)));
  }
}
