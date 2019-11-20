import 'package:flutter/foundation.dart';
import 'package:tailor_made/environments/environment.dart';

class Session {
  Session({@required Environment environment})
      : assert(environment != null),
        isMock = environment == Environment.MOCK,
        isDev = environment == Environment.DEVELOPMENT;

  final bool isMock;
  final bool isDev;
}
