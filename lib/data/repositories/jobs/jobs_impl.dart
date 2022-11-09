import 'dart:io';

import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';
import '../derive_list_from_data.dart';
import '../derive_map_from_data.dart';

class JobsImpl extends Jobs {
  JobsImpl({
    required this.firebase,
    required this.isDev,
  });

  final Firebase firebase;
  final bool isDev;

  @override
  Stream<List<JobModel>> fetchAll(String? userId) {
    return firebase.db
        .jobs(userId)
        .snapshots()
        .map((MapQuerySnapshot snapshot) => snapshot.docs.map(_deriveJobModel).toList());
  }

  @override
  FireStorage createFile(File file, String userId) {
    return FireStorage(firebase.storage.createReferenceImage(userId)..putFile(file));
  }

  @override
  Stream<JobModel> update(JobModel job, String userId) {
    final MapDocumentReference ref = firebase.db.jobs(userId).firestore.doc(job.id);
    ref.set(job.toJson()).then((_) {});
    return ref.snapshots().map(_deriveJobModel);
  }
}

JobModel _deriveJobModel(MapDocumentSnapshot snapshot) {
  final DynamicMap data = snapshot.data()!;
  return JobModel(
    reference: FireReference(snapshot.reference),
    id: data['id'] as String,
    userID: data['userID'] as String,
    contactID: data['contactID'] as String?,
    name: data['name'] as String,
    price: data['price'] as double,
    completedPayment: (data['completedPayment'] as num).toDouble(),
    pendingPayment: (data['pendingPayment'] as num).toDouble(),
    notes: data['notes'] as String? ?? '',
    images: deriveListFromMap(data['images'], ImageModel.fromJson),
    measurements: deriveMapFromMap(data['measurements'], (dynamic value) => value as double? ?? 0.0),
    payments: deriveListFromMap(data['payments'], PaymentModel.fromJson),
    isComplete: data['isComplete'] as bool,
    createdAt: DateTime.parse(data['createdAt'] as String),
    dueAt: DateTime.tryParse((data['dueAt'] as String?) ?? '') ?? DateTime.now(),
  );
}
