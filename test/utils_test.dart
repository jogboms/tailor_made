import 'package:flutter_test/flutter_test.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/utils/mk_group_model_by.dart';

void main() {
  group("group_mode_by", () {
    test('test group_mode_by', () {
      final _date = DateTime.now();
      const _id = "id_123456", _unit = "In";
      final List<MeasureModel> measures = [
        MeasureModel(group: "Blouse", name: "length", id: _id, unit: _unit, createdAt: _date),
        MeasureModel(group: "Blouse", name: "Waist", id: _id, unit: _unit, createdAt: _date),
        MeasureModel(group: "Trouser", name: "Waist", id: _id, unit: _unit, createdAt: _date),
        MeasureModel(group: "Trouser", name: "length", id: _id, unit: _unit, createdAt: _date),
        MeasureModel(group: "Blouse", name: "Arm", id: _id, unit: _unit, createdAt: _date),
      ];

      final grouped = groupModelBy<MeasureModel>(measures, (measure) => measure.group);

      expect(grouped.isNotEmpty, true);
      expect(grouped['Blouse'].length, 3);
      expect(grouped['Trouser'].length, 2);
    });
  });
}
