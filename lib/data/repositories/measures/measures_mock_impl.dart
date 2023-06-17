import 'package:tailor_made/domain.dart';

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
        id: '',
        name: 'Arm Hole',
        group: MeasureModelType.blouse,
        value: 20,
        createdAt: DateTime.now(),
      ),
      MeasureModel(
        id: '',
        name: 'Waist',
        group: MeasureModelType.blouse,
        value: 10,
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void>? update(List<MeasureModel> measures, String? userId) {
    return null;
  }
}
