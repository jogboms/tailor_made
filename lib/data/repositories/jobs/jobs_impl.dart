import 'dart:async';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';
import '../derive_list_from_data.dart';
import '../derive_map_from_data.dart';
import '../gallery/gallery_impl.dart';
import '../payments/payments_impl.dart';

class JobsImpl extends Jobs {
  JobsImpl({
    required this.firebase,
    required this.isDev,
  }) : collection = CloudDbCollection(firebase.db, collectionName);

  final Firebase firebase;
  final bool isDev;
  final CloudDbCollection collection;

  static const String collectionName = 'jobs';

  @override
  Stream<List<JobEntity>> fetchAll(String userId) {
    return collection.fetchAll().where('userID', isEqualTo: userId).snapshots().map(
          (MapQuerySnapshot snapshot) => snapshot.docs
              .map((MapQueryDocumentSnapshot doc) => _deriveJobEntity(doc.id, doc.reference.path, doc.data()))
              .toList(),
        );
  }

  @override
  FireFileStorageReference createFile(File file, String userId) {
    return FireFileStorageReference(firebase.storage.ref('$userId/references')..putFile(file));
  }

  @override
  Future<JobEntity> create(String userId, CreateJobData data) async {
    final Completer<JobEntity> completer = Completer<JobEntity>();
    final MapDocumentReference ref = collection.db.doc('jobs/${data.id}');
    unawaited(
      ref.set(<String, Object>{
        'id': data.id,
        'userID': data.userID,
        if (data.contactID != null) 'contactID': data.contactID!,
        'name': data.name,
        'price': data.price,
        'completedPayment': data.completedPayment,
        'pendingPayment': data.pendingPayment,
        'notes': data.notes,
        'images': data.images.map((_) => _.toJson()).toList(growable: false),
        'measurements': data.measurements,
        'payments': data.payments.map((_) => _.toJson()).toList(growable: false),
        'isComplete': data.isComplete,
        'createdAt': data.createdAt.toUtc().toString(),
        'dueAt': data.dueAt.toUtc().toString(),
      }),
    );

    StreamSubscription<JobEntity>? sub;
    void listener(JobEntity job) {
      completer.complete(job);
      sub?.cancel();
    }

    sub = ref
        .snapshots()
        .map((MapDocumentSnapshot doc) => _deriveJobEntity(doc.id, doc.reference.path, doc.data()!))
        .listen(listener);

    return completer.future;
  }

  @override
  Future<bool> update(
    String userId, {
    required ReferenceEntity reference,
    List<ImageEntity>? images,
    List<PaymentEntity>? payments,
    bool? isComplete,
    DateTime? dueAt,
  }) async {
    await collection.fetchOne(reference.id).update(<String, Object?>{
      if (images != null) 'images': images.map((_) => _.toJson()).toList(growable: false),
      if (payments != null) 'payments': payments.map((_) => _.toJson()).toList(growable: false),
      if (isComplete != null) 'isComplete': isComplete,
      if (dueAt != null) 'dueAt': dueAt.toUtc().toString(),
    });
    return true;
  }
}

JobEntity _deriveJobEntity(String id, String path, DynamicMap data) {
  final Map<String, dynamic> measurements = <String, dynamic>{
    ...?((data['measurements'] as Map<String, dynamic>?)?..removeWhere((_, dynamic value) => value == null)),
  };

  return JobEntity(
    reference: ReferenceEntity(id: id, path: path),
    id: data['id'] as String,
    userID: data['userID'] as String,
    contactID: data['contactID'] as String,
    name: data['name'] as String,
    price: data['price'] as double,
    completedPayment: (data['completedPayment'] as num).toDouble(),
    pendingPayment: (data['pendingPayment'] as num).toDouble(),
    notes: data['notes'] as String? ?? '',
    images: deriveListFromMap(
      data['images'],
      (Map<String, dynamic> data) => deriveImageEntity(
        data['id'] as String,
        null,
        data,
      ),
    ),
    measurements: deriveMapFromMap(measurements, (dynamic value) => value as double? ?? 0.0),
    payments: deriveListFromMap(
      data['payments'],
      (Map<String, dynamic> data) => derivePaymentEntity(
        data['id'] as String,
        null,
        data,
      ),
    ),
    isComplete: data['isComplete'] as bool,
    createdAt: DateTime.parse(data['createdAt'] as String),
    dueAt: DateTime.tryParse((data['dueAt'] as String?) ?? '') ?? clock.now(),
  );
}
