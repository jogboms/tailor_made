import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:tailor_made/domain.dart';

class FireUser implements User {
  FireUser(this._reference);

  final auth.User? _reference;

  @override
  String? get uid => _reference?.uid;
}

class FireStorage implements Storage {
  FireStorage(this._reference);

  final storage.Reference _reference;

  @override
  Future<void> delete() => _reference.delete();

  @override
  Future<String> getDownloadURL() => _reference.getDownloadURL();

  @override
  String get path => _reference.fullPath;
}

class FireReference implements Reference {
  FireReference(this._reference);

  final DocumentReference<Map<String, dynamic>> _reference;

  @override
  DocumentReference<Map<String, dynamic>> get source => _reference;

  @override
  Future<void> delete() => _reference.delete();

  @override
  Future<void> setData(Map<String, dynamic> data, {bool merge = false}) =>
      _reference.set(data, SetOptions(merge: true));

  @override
  Future<void> updateData(Map<String, dynamic> data) => _reference.update(data);
}
