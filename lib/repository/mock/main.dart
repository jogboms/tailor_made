import 'package:tailor_made/repository/main.dart';

class MockRepository extends Repository {}

Future<MockRepository> repositoryFactory() async => MockRepository();
