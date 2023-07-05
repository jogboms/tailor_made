import 'package:tailor_made/domain.dart';

abstract class Measures {
  Stream<List<MeasureEntity>> fetchAll(String userId);

  Future<bool> create(
    List<BaseMeasureEntity> measures,
    String userId, {
    required MeasureGroup group,
    required String unit,
  });

  Future<bool> deleteGroup(List<MeasureEntity> measures, String userId);

  Future<bool> deleteOne(ReferenceEntity reference);

  Future<bool> update(Iterable<BaseMeasureEntity> measures, String userId);

  Future<bool> updateOne(
    ReferenceEntity reference, {
    String? name,
  });
}
