import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/services/measures/measures.dart';

class MeasuresMockImpl extends Measures {
  @override
  Future<void>? create(List<MeasureModel>? measures, String userId, {String? groupName, String? unitValue}) {
    return null;
  }

  @override
  Future<void>? delete(List<MeasureModel> measures, String userId) {
    return null;
  }

  @override
  Stream<List<MeasureModel>> fetchAll(String? userId) async* {
    yield <MeasureModel>[
      MeasureModel(
        (MeasureModelBuilder b) => b
          ..name = 'Arm Hole'
          ..value = 10
          ..group = MeasureModelType.blouse,
      ),
      MeasureModel(
        (MeasureModelBuilder b) => b
          ..name = 'Shoulder'
          ..value = 10
          ..group = MeasureModelType.blouse,
      ),
    ];
  }

  @override
  Future<void>? update(List<MeasureModel> measures, String? userId) {
    return null;
  }
}
