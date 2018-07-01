import 'package:tailor_made/models/main.dart';

class MeasureModel extends Model {
  String name;
  String value;
  String unit;

  MeasureModel({
    this.name,
    this.value,
    this.unit = "In",
  });

  factory MeasureModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new MeasureModel(
      name: json['name'],
      value: json['value'],
      unit: json['unit'],
    );
  }

  @override
  toMap() {
    return {
      "name": name,
      "value": value,
      "unit": unit,
    };
  }
}
