import 'dart:async';

import 'package:clock/clock.dart';
import 'package:tailor_made/domain.dart';
import 'package:uuid/uuid.dart';

import '../../network/firebase.dart';
import '../derive_map_from_data.dart';

class ContactsImpl extends Contacts {
  ContactsImpl({
    required this.firebase,
    required this.isDev,
  }) : collection = CloudDbCollection(firebase.db, collectionName);

  final Firebase firebase;
  final bool isDev;
  final CloudDbCollection collection;

  static const String collectionName = 'contacts';

  @override
  Stream<List<ContactEntity>> fetchAll(String? userId) {
    return firebase.db.collection(collectionName).where('userID', isEqualTo: userId).snapshots().map(
          (MapQuerySnapshot snapshot) => snapshot.docs
              .where((MapQueryDocumentSnapshot doc) => doc.data().containsKey('fullname'))
              .map((MapQueryDocumentSnapshot doc) => _deriveContactEntity(doc.id, doc.reference.path, doc.data()))
              .toList(),
        );
  }

  @override
  Future<ImageFileReference> createFile({required String path, required String userId}) {
    return firebase.storage.create('$userId/$collectionName', filePath: path);
  }

  @override
  Future<bool> deleteFile({required ImageFileReference reference, required String userId}) async {
    await firebase.storage.delete(src: reference.src);
    return true;
  }

  @override
  Future<ContactEntity> create(String userId, CreateContactData data) async {
    final String id = const Uuid().v4();
    final Completer<ContactEntity> completer = Completer<ContactEntity>();
    final MapDocumentReference ref = collection.db.doc('$collectionName/$id');
    unawaited(
      ref.set(<String, Object>{
        'id': id,
        'userID': userId,
        'fullname': data.fullname,
        'phone': data.phone,
        'location': data.location,
        if (data.imageUrl != null) 'imageUrl': data.imageUrl!,
        'createdAt': clock.now().toIso8601String(),
        'measurements': data.measurements,
      }),
    );

    StreamSubscription<ContactEntity>? sub;
    void listener(ContactEntity job) {
      completer.complete(job);
      sub?.cancel();
    }

    sub = ref
        .snapshots()
        .map(
          (MapDocumentSnapshot snapshot) => _deriveContactEntity(
            snapshot.id,
            snapshot.reference.path,
            snapshot.data()!,
          ),
        )
        .listen(listener);

    return completer.future;
  }

  @override
  Future<bool> update(
    String userId, {
    required ReferenceEntity reference,
    String? fullname,
    String? phone,
    String? location,
    String? imageUrl,
    Map<String, double>? measurements,
  }) async {
    await collection.fetchOne(reference.id).update(<String, Object?>{
      if (fullname != null) 'fullname': fullname,
      if (phone != null) 'phone': phone,
      if (location != null) 'location': location,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (measurements != null) 'measurements': measurements,
    });
    return true;
  }
}

ContactEntity _deriveContactEntity(String id, String path, DynamicMap data) {
  final Map<String, dynamic> measurements = <String, dynamic>{
    ...?((data['measurements'] as Map<String, dynamic>?)?..removeWhere((_, dynamic value) => value == null)),
  };

  return ContactEntity(
    reference: ReferenceEntity(id: id, path: path),
    id: data['id'] as String,
    userID: data['userID'] as String,
    fullname: data['fullname'] as String,
    phone: data['phone'] as String,
    location: data['location'] as String,
    imageUrl: data['imageUrl'] as String?,
    createdAt: DateTime.parse(data['createdAt'] as String),
    measurements: deriveMapFromMap(measurements, (dynamic value) => _isA<double>(value) ?? 0.0),
    totalJobs: _isA<int>(data['totalJobs']) ?? 0,
    pendingJobs: _isA<int>(data['pendingJobs']) ?? 0,
  );
}

T? _isA<T>(Object? value) => value is T ? value : null;
