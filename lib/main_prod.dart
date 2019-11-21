import 'package:tailor_made/environments/environment.dart';
import 'package:tailor_made/main.dart' as def;
import 'package:tailor_made/repository/firebase/main.dart';

void main() => def.main(repositoryFactory, delay: 1, environment: Environment.PRODUCTION);
