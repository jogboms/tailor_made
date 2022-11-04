import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Snapshot {
  Map<String, dynamic>? get data;
  Reference get reference;
}

abstract class User {
  String? get uid;
}

abstract class Storage {
  Future<void> delete();

  Future<String> getDownloadURL();

  String get path;
}

abstract class Reference {
  DocumentReference<Map<String, dynamic>> get source;

  Future<void> delete();

  Future<void> setData(Map<String, dynamic> data, {bool merge = false});

  Future<void> updateData(Map<String, dynamic> data);
}
