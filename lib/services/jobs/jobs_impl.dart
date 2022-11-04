import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/repository/firebase/main.dart';
import 'package:tailor_made/repository/firebase/models.dart';
import 'package:tailor_made/services/jobs/jobs.dart';

class JobsImpl extends Jobs {
  JobsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<JobModel>> fetchAll(String? userId) {
    return repository.db.jobs(userId).snapshots().map(
          (QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs
              .map((QueryDocumentSnapshot<Map<String, dynamic>> item) => JobModel.fromSnapshot(FireSnapshot(item)))
              .toList(),
        );
  }

  @override
  FireStorage createFile(File file, String userId) {
    return FireStorage(repository.storage.createReferenceImage(userId)..putFile(file));
  }

  @override
  Stream<JobModel> update(JobModel job, String userId) {
    final DocumentReference<Map<String, dynamic>> ref = repository.db.jobs(userId).firestore.doc(job.id!);
    ref.set(job.toMap()).then((_) {});
    return ref
        .snapshots()
        .map((DocumentSnapshot<Map<String, dynamic>> doc) => JobModel.fromSnapshot(FireSnapshot(doc)));
  }
}
