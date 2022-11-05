import 'package:tailor_made/environments/environment.dart';

class Session {
  Session({required Environment environment})
      : isMock = environment == Environment.mock,
        isDev = environment == Environment.development;

  final bool isMock;
  final bool isDev;
}
