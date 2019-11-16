import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/services/measures/measures.dart';

class MeasuresMockImpl extends Measures {
  @override
  Future<void> create(List<MeasureModel> measures, String userId, {String groupName, String unitValue}) {
    // TODO: implement create
    return null;
  }

  @override
  Future<void> delete(List<MeasureModel> measures, String userId) {
    // TODO: implement delete
    return null;
  }

  @override
  Stream<List<MeasureModel>> fetchAll(String userId) async* {
    // TODO: implement fetchAll
    yield [];
  }

  @override
  Future<void> update(List<MeasureModel> measures, String userId) {
    // TODO: implement update
    return null;
  }
}
