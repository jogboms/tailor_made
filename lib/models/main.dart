import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Model {
  DocumentReference reference;

  Map<String, dynamic> toMap();

  @override
  String toString() {
    return json.encode(toMap());
  }
}
