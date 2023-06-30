import '../entities.dart';

abstract class Gallery {
  Stream<List<ImageEntity>> fetchAll(String userId);
}
