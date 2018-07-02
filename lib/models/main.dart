import 'dart:convert';

abstract class Model {
  toMap();

  toString() {
    return json.encode(toMap());
  }
}
