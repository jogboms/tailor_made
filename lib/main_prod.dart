import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/main.dart' as def;
import 'package:tailor_made/repository/firebase/main.dart';

// NOTE: so flutter has enough time to calculate sizes
void main() => def.main(factory(), delay: 1, environment: Environment.PRODUCTION);
