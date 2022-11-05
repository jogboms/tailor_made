import 'core.dart';
import 'data.dart';
import 'main.dart' as def;

// NOTE: so flutter has enough time to calculate sizes
void main(List<String> args) => def.main(args, repositoryFactory, delay: 1, environment: Environment.production);
