import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Snapshot {
  Snapshot(DocumentSnapshot doc)
      : data = doc.data,
        reference = Reference(doc.reference);

  final Map<String, dynamic> data;
  final Reference reference;
}

class User {
  User(this._reference);

  final FirebaseUser _reference;

  String get uid => _reference.uid;
}

class Storage {
  Storage(this._reference);

  final StorageReference _reference;

  Future<void> delete() => _reference.delete();

  Future getDownloadURL() => _reference.getDownloadURL();

  String get path => _reference.path;
}

class Reference {
  Reference(this._reference);

  final DocumentReference _reference;

  DocumentReference get source => _reference;

  Future<void> delete() => _reference.delete();

  Future<void> setData(Map<String, dynamic> data, {bool merge = false}) => _reference.setData(data, merge: merge);

  Future<void> updateData(Map<String, dynamic> data) => _reference.updateData(data);
}
