import 'dart:io';

import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/jobs/jobs.dart';

class JobsImpl extends Jobs {
  JobsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<JobModel>> fetchAll(String userId) {
    return repository.db
        .jobs(userId)
        .snapshots()
        .map((snapshot) => snapshot.documents.map((item) => JobModel.fromSnapshot(FireSnapshot(item))).toList());
  }

  @override
  FireStorage createFile(File file, String userId) {
    return FireStorage(repository.storage.createReferenceImage(userId)..putFile(file));
  }

  @override
  Stream<JobModel> update(JobModel job, String userId) {
    final ref = repository.db.jobs(userId).reference().document(job.id);
    ref.setData(job.toMap()).then((r) {});
    return ref.snapshots().map((doc) => JobModel.fromSnapshot(FireSnapshot(doc)));
  }
}
