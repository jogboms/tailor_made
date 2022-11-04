import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/main.dart' as def;
import 'package:tailor_made/repository/firebase/main.dart';

// NOTE: so flutter has enough time to calculate sizes
void main(List<String> args) => def.main(args, repositoryFactory, delay: 1, environment: Environment.production);
