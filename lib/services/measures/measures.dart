import 'package:tailor_made/models/measure.dart';

abstract class Measures {
  Stream<List<MeasureModel>> fetchAll(String? userId);

  Future<void>? create(
    List<MeasureModel>? measures,
    String userId, {
    required String? groupName,
    required String? unitValue,
  });

  Future<void>? delete(List<MeasureModel> measures, String userId);

  Future<void>? update(List<MeasureModel> measures, String? userId);
}
