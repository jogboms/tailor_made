import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ModelInterface {
  DocumentReference reference;

  Model clone() => null;

  Map<String, dynamic> toMap();

  Map<String, dynamic> toJson() => toMap();

  @override
  String toString() => Model.mapToString(toMap());

  dynamic operator [](String key) => toMap()[key];
}

abstract class Model with ModelInterface {
  static String mapToString(Map<String, dynamic> map) {
    return json.encode(map);
  }

  static Map<String, dynamic> stringToMap(String string) {
    if (string == null || string.isEmpty) {
      return null;
    }
    try {
      return json.decode(string);
    } catch (e) {
      return null;
    }
  }
}
