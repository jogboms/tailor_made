import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:tailor_made/repository/models.dart';

class FireSnapshot implements Snapshot<DocumentSnapshot> {
  FireSnapshot(DocumentSnapshot doc)
      : data = doc.data,
        reference = FireReference(doc.reference);

  @override
  final Map<String, dynamic> data;
  @override
  final FireReference reference;
}

class FireUser implements User {
  FireUser(this._reference);

  final FirebaseUser _reference;

  @override
  String get uid => _reference.uid;
}

class FireStorage implements Storage {
  FireStorage(this._reference);

  final StorageReference _reference;

  @override
  Future<void> delete() => _reference.delete();

  @override
  Future getDownloadURL() => _reference.getDownloadURL();

  @override
  String get path => _reference.path;
}

class FireReference implements Reference<DocumentReference> {
  FireReference(this._reference);

  final DocumentReference _reference;

  @override
  DocumentReference get source => _reference;

  @override
  Future<void> delete() => _reference.delete();

  @override
  Future<void> setData(Map<String, dynamic> data, {bool merge = false}) => _reference.setData(data, merge: merge);

  @override
  Future<void> updateData(Map<String, dynamic> data) => _reference.updateData(data);
}
