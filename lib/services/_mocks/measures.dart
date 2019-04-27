import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/services/measures.dart';

class MeasuresMockImpl extends Measures {
  @override
  Future<void> create(List<MeasureModel> measures,
      {String groupName, String unitValue}) {
    // TODO: implement create
    return null;
  }

  @override
  Future<void> delete(List<MeasureModel> measures) {
    // TODO: implement delete
    return null;
  }

  @override
  Stream<List<MeasureModel>> fetchAll() {
    // TODO: implement fetchAll
    return null;
  }

  @override
  Future<void> update(List<MeasureModel> measures) {
    // TODO: implement update
    return null;
  }
}
