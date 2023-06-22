import 'package:tailor_made/domain.dart';

abstract class Measures {
  Stream<List<MeasureEntity>> fetchAll(String? userId);

  Future<void>? create(
    List<BaseMeasureEntity> measures,
    String userId, {
    required MeasureGroup? groupName,
    required String? unitValue,
  });

  Future<void>? delete(List<MeasureEntity> measures, String userId);

  Future<bool> deleteOne(ReferenceEntity reference);

  Future<void>? update(Iterable<BaseMeasureEntity> measures, String? userId);

  Future<bool> updateOne(
    ReferenceEntity reference, {
    String? name,
  });
}
