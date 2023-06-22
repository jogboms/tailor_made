import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_made/core.dart';
import 'package:tailor_made/domain.dart';

void main() {
  group('group_mode_by', () {
    test('test group_mode_by', () {
      final List<DefaultMeasureEntity> measures = <DefaultMeasureEntity>[
        const DefaultMeasureEntity(group: MeasureGroup.blouse, name: 'length'),
        const DefaultMeasureEntity(group: MeasureGroup.blouse, name: 'Waist'),
        const DefaultMeasureEntity(group: MeasureGroup.trouser, name: 'Waist'),
        const DefaultMeasureEntity(group: MeasureGroup.trouser, name: 'length'),
        const DefaultMeasureEntity(group: MeasureGroup.blouse, name: 'Arm'),
      ];

      final Map<MeasureGroup, List<DefaultMeasureEntity>> grouped = groupBy<MeasureGroup, DefaultMeasureEntity>(
        measures,
        (DefaultMeasureEntity measure) => measure.group,
      );

      expect(grouped.isNotEmpty, true);
      expect(grouped['Blouse']!.length, 3);
      expect(grouped['Trouser']!.length, 2);
    });
  });
}
