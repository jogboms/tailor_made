import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/main.dart' as def;

// NOTE: so flutter has enough time to calculate sizes
void main() => def.main(delay: 1, environment: Environment.PRODUCTION);
