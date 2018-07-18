import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/main.dart';

List<MeasureModel> createDefaultMeasures() {
  return [
    MeasureModel(name: "Arm Hole", type: MeasureModelType.blouse),
    MeasureModel(name: "Shoulder", type: MeasureModelType.blouse),
    MeasureModel(name: "Bust", type: MeasureModelType.blouse),
    MeasureModel(name: "Bust Point", type: MeasureModelType.blouse),
    MeasureModel(name: "Shoulder - Bust Point", type: MeasureModelType.blouse),
    MeasureModel(name: "Shoulder - Under Bust", type: MeasureModelType.blouse),
    MeasureModel(name: "Shoulder - Waist", type: MeasureModelType.blouse),
    MeasureModel(name: "Length", type: MeasureModelType.trouser),
    MeasureModel(name: "Waist", type: MeasureModelType.trouser),
    MeasureModel(name: "Crouch", type: MeasureModelType.trouser),
    MeasureModel(name: "Thigh", type: MeasureModelType.trouser),
    MeasureModel(name: "Body Rise", type: MeasureModelType.trouser),
    MeasureModel(name: "Width", type: MeasureModelType.trouser),
    MeasureModel(name: "Hip", type: MeasureModelType.trouser),
    MeasureModel(name: "Full Length", type: MeasureModelType.skirts),
    MeasureModel(name: "Short Length", type: MeasureModelType.skirts),
    MeasureModel(name: "Knee Length", type: MeasureModelType.skirts),
    MeasureModel(name: "Hip", type: MeasureModelType.skirts),
    MeasureModel(name: "Waist", type: MeasureModelType.gown),
    MeasureModel(name: "Long Length", type: MeasureModelType.gown),
    MeasureModel(name: "Short Length", type: MeasureModelType.gown),
    MeasureModel(name: "Knee Length", type: MeasureModelType.gown),
  ];
}

class MeasureModelType {
  static String blouse = "Blouse";
  static String trouser = "Trouser";
  static String skirts = "Skirts";
  static String gown = "Gown";
}

class MeasureModel extends Model {
  String name;
  double value;
  String unit;
  String type;

  MeasureModel({
    @required this.name,
    this.value = 0.0,
    this.unit = "In",
    @required this.type,
  });

  factory MeasureModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new MeasureModel(
      name: json['name'],
      value: double.tryParse(json['value'].toString()),
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
