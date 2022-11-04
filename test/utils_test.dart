import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/utils/mk_group_model_by.dart';

void main() {
  group('group_mode_by', () {
    test('test group_mode_by', () {
      final DateTime date = DateTime.now();
      const String id = 'id_123456', unit = 'In';
      final List<MeasureModel> measures = <MeasureModel>[
        MeasureModel(
          (MeasureModelBuilder b) => b
            ..group = 'Blouse'
            ..name = 'length'
            ..id = id
            ..unit = unit
            ..createdAt = date,
        ),
        MeasureModel(
          (MeasureModelBuilder b) => b
            ..group = 'Blouse'
            ..name = 'Waist'
            ..id = id
            ..unit = unit
            ..createdAt = date,
        ),
        MeasureModel(
          (MeasureModelBuilder b) => b
            ..group = 'Trouser'
            ..name = 'Waist'
            ..id = id
            ..unit = unit
            ..createdAt = date,
        ),
        MeasureModel(
          (MeasureModelBuilder b) => b
            ..group = 'Trouser'
            ..name = 'length'
            ..id = id
            ..unit = unit
            ..createdAt = date,
        ),
        MeasureModel(
          (MeasureModelBuilder b) => b
            ..group = 'Blouse'
            ..name = 'Arm'
            ..id = id
            ..unit = unit
            ..createdAt = date,
        ),
      ];

      final Map<String, List<MeasureModel>> grouped = groupModelBy<MeasureModel>(measures, (MeasureModel measure) => measure.group);

      expect(grouped.isNotEmpty, true);
      expect(grouped['Blouse']!.length, 3);
      expect(grouped['Trouser']!.length, 2);
    });
  });
}
