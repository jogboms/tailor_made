import 'package:tailor_made/repository/models.dart';

class MockUser implements User {
  const MockUser([this.uid = '1']);

  @override
  final String uid;
}
