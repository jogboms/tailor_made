import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/main.dart' as def;
import 'package:tailor_made/repository/firebase/main.dart';

void main(List<String> args) => def.main(args, repositoryFactory, delay: 2, environment: Environment.development);
