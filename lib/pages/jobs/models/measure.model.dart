import 'package:tailor_made/models/main.dart';

class MeasureModelType {
  static String blouse = "Blouse";
  static String trouser = "Trouser";
  static String skirts = "Skirts";
  static String gown = "Gown";
}

class MeasureModel extends Model {
  String name;
  String value;
  String unit;
  String type;

  MeasureModel({
    this.name,
    this.value,
    this.unit = "In",
    this.type,
  });

  factory MeasureModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new MeasureModel(
      name: json['name'],
      value: json['value'],
      unit: json['unit'],
      type: json['type'],
    );
  }

  @override
  toMap() {
    return {
      "name": name,
      "value": value,
      "unit": unit,
      "type": type,
    };
  }
}
