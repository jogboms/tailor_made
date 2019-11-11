import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Model {
  DocumentReference reference;

  Map<String, dynamic> toMap();

  Model clone() => null;

  static DateTime parseTimestamp(String timestamp) {
    try {
      return DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp));
    } catch (e) {
      return DateTime.now();
    }
  }

  static List<T> generator<T>(dynamic items, Function(dynamic) cb) {
    return List<T>.generate(
      items != null ? items.length : 0,
      (int index) => cb(items[index]),
    );
  }

  Map<String, dynamic> toJson() => toMap();

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

  @override
  String toString() => mapToString(toMap());

  dynamic operator [](String key) => toMap()[key];
}
