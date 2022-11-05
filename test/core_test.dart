import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';

void main() {
  group('group_mode_by', () {
    test('test group_mode_by', () {
      final DateTime date = DateTime.now();
      const String id = 'id_123456';
      final List<MeasureModel> measures = <MeasureModel>[
        MeasureModel(
          group: 'Blouse',
          name: 'length',
          id: id,
          createdAt: date,
        ),
        MeasureModel(
          group: 'Blouse',
          name: 'Waist',
          id: id,
          createdAt: date,
        ),
        MeasureModel(
          group: 'Trouser',
          name: 'Waist',
          id: id,
          createdAt: date,
        ),
        MeasureModel(
          group: 'Trouser',
          name: 'length',
          id: id,
          createdAt: date,
        ),
        MeasureModel(
          group: 'Blouse',
          name: 'Arm',
          id: id,
          createdAt: date,
        ),
      ];

      final Map<String, List<MeasureModel>> grouped =
          groupBy<MeasureModel>(measures, (MeasureModel measure) => measure.group);

      expect(grouped.isNotEmpty, true);
      expect(grouped['Blouse']!.length, 3);
      expect(grouped['Trouser']!.length, 2);
    });
  });
}
