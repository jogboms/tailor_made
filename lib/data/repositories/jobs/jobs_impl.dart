import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class JobsImpl extends Jobs {
  JobsImpl(this.repository);

  final FirebaseRepository repository;

  @override
  Stream<List<JobModel>> fetchAll(String? userId) {
    return repository.db
        .jobs(userId)
        .snapshots()
        .map((QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs.map(_deriveJobModel).toList());
  }

  @override
  FireStorage createFile(File file, String userId) {
    return FireStorage(repository.storage.createReferenceImage(userId)..putFile(file));
  }

  @override
  Stream<JobModel> update(JobModel job, String userId) {
    final DocumentReference<Map<String, dynamic>> ref = repository.db.jobs(userId).firestore.doc(job.id);
    ref.set(job.toJson()).then((_) {});
    return ref.snapshots().map(_deriveJobModel);
  }
}

JobModel _deriveJobModel(DocumentSnapshot<Map<String, dynamic>> snapshot) {
  final Map<String, dynamic> data = snapshot.data()!;
  return JobModel(
    reference: FireReference(snapshot.reference),
    id: data['id'] as String,
    userID: data['userID'] as String,
    contactID: data['contactID'] as String?,
    name: data['name'] as String,
    price: data['price'] as double,
    completedPayment: data['completedPayment'] as double,
    pendingPayment: data['pendingPayment'] as double,
    notes: data['notes'] as String? ?? '',
    images: data['images'] as List<ImageModel>? ?? const <ImageModel>[],
    measurements: data['measurements'] as Map<String, double>? ?? <String, double>{},
    payments: data['payments'] as List<PaymentModel>? ?? const <PaymentModel>[],
    isComplete: data['isComplete'] as bool,
    createdAt: data['createdAt'] as DateTime,
    dueAt: data['dueAt'] as DateTime?,
  );
}
