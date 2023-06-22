import 'package:tailor_made/domain.dart';

class MeasuresMockImpl extends Measures {
  @override
  Future<void>? create(
    List<BaseMeasureEntity> measures,
    String userId, {
    MeasureGroup? groupName,
    String? unitValue,
  }) {
    return null;
  }

  @override
  Future<void>? delete(List<MeasureEntity> measures, String userId) {
    return null;
  }

  @override
  Future<bool> deleteOne(ReferenceEntity reference) async => true;

  @override
  Stream<List<MeasureEntity>> fetchAll(String? userId) async* {
    yield <MeasureEntity>[
      MeasureEntity(
        reference: const ReferenceEntity(id: 'id', path: 'path'),
        id: '',
        name: 'Arm Hole',
        group: MeasureGroup.blouse,
        value: 20,
        createdAt: DateTime.now(),
      ),
      MeasureEntity(
        reference: const ReferenceEntity(id: 'id', path: 'path'),
        id: '',
        name: 'Waist',
        group: MeasureGroup.blouse,
        value: 10,
        createdAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void>? update(Iterable<BaseMeasureEntity> measures, String? userId) {
    return null;
  }

  @override
  Future<bool> updateOne(ReferenceEntity reference, {String? name}) async => true;
}
