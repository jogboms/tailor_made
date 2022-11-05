import 'domain.dart';
import 'main.dart' as def;

void main(List<String> args) => def.main(args, () async => MockRepository(), delay: 2);

class MockRepository extends Repository {}
