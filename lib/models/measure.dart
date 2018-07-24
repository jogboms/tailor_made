import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/utils/tm_uuid.dart';

List<MeasureModel> createDefaultMeasures() {
  return [
    MeasureModel(name: 'Arm Hole', group: MeasureModelType.blouse),
    MeasureModel(name: 'Shoulder', group: MeasureModelType.blouse),
    MeasureModel(name: 'Bust', group: MeasureModelType.blouse),
    MeasureModel(name: 'Bust Point', group: MeasureModelType.blouse),
    MeasureModel(name: 'Shoulder - Bust Point', group: MeasureModelType.blouse),
    MeasureModel(name: 'Shoulder - Under Bust', group: MeasureModelType.blouse),
    MeasureModel(name: 'Shoulder - Waist', group: MeasureModelType.blouse),
    MeasureModel(name: 'Length', group: MeasureModelType.trouser),
    MeasureModel(name: 'Waist', group: MeasureModelType.trouser),
    MeasureModel(name: 'Crouch', group: MeasureModelType.trouser),
    MeasureModel(name: 'Thigh', group: MeasureModelType.trouser),
    MeasureModel(name: 'Body Rise', group: MeasureModelType.trouser),
    MeasureModel(name: 'Width', group: MeasureModelType.trouser),
    MeasureModel(name: 'Hip', group: MeasureModelType.trouser),
    MeasureModel(name: 'Full Length', group: MeasureModelType.skirts),
    MeasureModel(name: 'Short Length', group: MeasureModelType.skirts),
    MeasureModel(name: 'Knee Length', group: MeasureModelType.skirts),
    MeasureModel(name: 'Hip', group: MeasureModelType.skirts),
    MeasureModel(name: 'Waist', group: MeasureModelType.gown),
    MeasureModel(name: 'Long Length', group: MeasureModelType.gown),
    MeasureModel(name: 'Short Length', group: MeasureModelType.gown),
    MeasureModel(name: 'Knee Length', group: MeasureModelType.gown),
  ];
}

class MeasureModelType {
  static String blouse = 'Blouse';
  static String trouser = 'Trouser';
  static String skirts = 'Skirts';
  static String gown = 'Gown';
}

class MeasureModel extends Model {
  String id;
  String name;
  // TODO remove
  double value;
  String unit;
  String group;
  DateTime createdAt;

  MeasureModel({
    String id,
    @required this.name,
    // TODO remove
    this.value = 0.0,
    this.unit = 'In',
    DateTime createdAt,
    @required this.group,
  })  : id = id ?? uuid(),
        createdAt = createdAt ?? DateTime.now();

  factory MeasureModel.fromJson(Map<String, dynamic> json) {
    assert(json != null);
    return new MeasureModel(
      id: json['id'],
      name: json['name'],
      // TODO remove
      value: double.tryParse(json['value'].toString()),
      unit: json['unit'],
      group: json['type'],
      createdAt: DateTime.tryParse(json['createdAt'].toString()),
    );
  }

  factory MeasureModel.fromDoc(DocumentSnapshot doc) {
    return MeasureModel.fromJson(doc.data)..reference = doc.reference;
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      // TODO remove
      'value': value,
      'unit': unit,
      'type': group,
      'createdAt': createdAt.toString(),
    };
  }
}
