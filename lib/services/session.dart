import 'package:flutter/foundation.dart';
import 'package:tailor_made/environments/environment.dart';

class Session {
  Session({@required Environment environment})
      : assert(environment != null),
        isMock = environment == Environment.MOCK;

  final bool isMock;
}
