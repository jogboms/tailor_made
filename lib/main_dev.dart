import 'core.dart';
import 'data.dart';
import 'main.dart' as def;

void main(List<String> args) => def.main(args, repositoryFactory, delay: 2, environment: Environment.development);
