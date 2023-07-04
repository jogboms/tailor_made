import 'package:clock/clock.dart';
import 'package:tailor_made/domain.dart';

class MeasuresMockImpl extends Measures {
  @override
  Future<bool> create(
    List<BaseMeasureEntity> measures,
    String userId, {
    required MeasureGroup group,
    required String unit,
  }) async =>
      true;

  @override
  Future<bool> deleteGroup(List<MeasureEntity> measures, String userId) async => true;

  @override
  Future<bool> deleteOne(ReferenceEntity reference) async => true;

  @override
  Stream<List<MeasureEntity>> fetchAll(String userId) async* {
    yield <MeasureEntity>[
      MeasureEntity(
        reference: const ReferenceEntity(id: 'id', path: 'path'),
        id: '',
        name: 'Arm Hole',
        group: MeasureGroup.blouse,
        createdAt: clock.now(),
      ),
      MeasureEntity(
        reference: const ReferenceEntity(id: 'id', path: 'path'),
        id: '',
        name: 'Waist',
        group: MeasureGroup.blouse,
        createdAt: clock.now(),
      ),
    ];
  }

  @override
  Future<bool> update(Iterable<BaseMeasureEntity> measures, String userId) async => true;

  @override
  Future<bool> updateOne(ReferenceEntity reference, {String? name}) async => true;
}
