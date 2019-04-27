import 'package:injector/injector.dart';
import 'package:meta/meta.dart';
import 'package:tailor_made/models/measure.dart';

abstract class Measures {
  static Measures di() {
    return Injector.appInstance.getDependency<Measures>();
  }

  Stream<List<MeasureModel>> fetchAll();

  Future<void> create(
    List<MeasureModel> measures, {
    @required String groupName,
    @required String unitValue,
  });

  Future<void> delete(List<MeasureModel> measures);

  Future<void> update(List<MeasureModel> measures);
}
