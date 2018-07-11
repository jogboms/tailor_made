import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Model {
  DocumentReference reference;

  toMap();

  toString() {
    return json.encode(toMap());
  }
}
