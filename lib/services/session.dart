import 'package:flutter/foundation.dart';
import 'package:tailor_made/environments/environment.dart';

class Session {
  Session({@required Environment environment})
      : assert(environment != null),
        isMock = environment == Environment.MOCK,
        user = _User();

  final bool isMock;
  final _User user;
}

class _User {
  String _id;

  void setId(String id) {
    assert(id != null);
    _id = id;
  }

  String getId() => _id;
}
