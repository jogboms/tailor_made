import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:tailor_made/domain.dart';

class FireFileStorageReference implements FileStorageReference {
  FireFileStorageReference(this._reference);

  final storage.Reference _reference;

  @override
  Future<void> delete() => _reference.delete();

  @override
  Future<String> getDownloadURL() => _reference.getDownloadURL();

  @override
  String get path => _reference.fullPath;
}

typedef DynamicMap = Map<String, dynamic>;
typedef MapQuery = Query<DynamicMap>;
typedef MapQuerySnapshot = QuerySnapshot<DynamicMap>;
typedef MapQueryDocumentSnapshot = QueryDocumentSnapshot<DynamicMap>;
typedef MapDocumentSnapshot = DocumentSnapshot<DynamicMap>;
typedef MapDocumentReference = DocumentReference<DynamicMap>;
typedef MapCollectionReference = CollectionReference<DynamicMap>;

typedef CloudTimestamp = Timestamp;
typedef CloudValue = FieldValue;
