import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/firebase/models.dart';
import 'package:tailor_made/models/main.dart';
import 'package:tailor_made/models/serializers.dart';
import 'package:uuid/uuid.dart';

part 'measure.g.dart';

List<MeasureModel> createDefaultMeasures() {
  return [
    MeasureModel((b) => b
      ..name = 'Arm Hole'
      ..group = MeasureModelType.blouse),
    MeasureModel((b) => b
      ..name = 'Shoulder'
      ..group = MeasureModelType.blouse),
    MeasureModel((b) => b
      ..name = 'Bust'
      ..group = MeasureModelType.blouse),
    MeasureModel((b) => b
      ..name = 'Bust Point'
      ..group = MeasureModelType.blouse),
    MeasureModel((b) => b
      ..name = 'Shoulder - Bust Point'
      ..group = MeasureModelType.blouse),
    MeasureModel((b) => b
      ..name = 'Shoulder - Under Bust'
      ..group = MeasureModelType.blouse),
    MeasureModel((b) => b
      ..name = 'Shoulder - Waist'
      ..group = MeasureModelType.blouse),
    MeasureModel((b) => b
      ..name = 'Length'
      ..group = MeasureModelType.trouser),
    MeasureModel((b) => b
      ..name = 'Waist'
      ..group = MeasureModelType.trouser),
    MeasureModel((b) => b
      ..name = 'Crouch'
      ..group = MeasureModelType.trouser),
    MeasureModel((b) => b
      ..name = 'Thigh'
      ..group = MeasureModelType.trouser),
    MeasureModel((b) => b
      ..name = 'Body Rise'
      ..group = MeasureModelType.trouser),
    MeasureModel((b) => b
      ..name = 'Width'
      ..group = MeasureModelType.trouser),
    MeasureModel((b) => b
      ..name = 'Hip'
      ..group = MeasureModelType.trouser),
    MeasureModel((b) => b
      ..name = 'Full Length'
      ..group = MeasureModelType.skirts),
    MeasureModel((b) => b
      ..name = 'Short Length'
      ..group = MeasureModelType.skirts),
    MeasureModel((b) => b
      ..name = 'Knee Length'
      ..group = MeasureModelType.skirts),
    MeasureModel((b) => b
      ..name = 'Hip'
      ..group = MeasureModelType.skirts),
    MeasureModel((b) => b
      ..name = 'Waist'
      ..group = MeasureModelType.gown),
    MeasureModel((b) => b
      ..name = 'Long Length'
      ..group = MeasureModelType.gown),
    MeasureModel((b) => b
      ..name = 'Short Length'
      ..group = MeasureModelType.gown),
    MeasureModel((b) => b
      ..name = 'Knee Length'
      ..group = MeasureModelType.gown),
  ];
}

class MeasureModelType {
  static String blouse = 'Blouse';
  static String trouser = 'Trouser';
  static String skirts = 'Skirts';
  static String gown = 'Gown';
}

abstract class MeasureModel with ModelInterface implements Built<MeasureModel, MeasureModelBuilder> {
  factory MeasureModel([void updates(MeasureModelBuilder b)]) = _$MeasureModel;

  MeasureModel._();

  factory MeasureModel.fromSnapshot(Snapshot snapshot) =>
      MeasureModel.fromJson(snapshot.data)..reference = snapshot.reference;

  static void _initializeBuilder(MeasureModelBuilder b) => b
    ..id = Uuid().v1()
    ..value = 0.0
    ..unit = "In"
    ..createdAt = DateTime.now();

  String get id;

  String get name;

  @nullable
  double get value;

  String get unit;

  String get group;

  DateTime get createdAt;

  @override
  Map<String, dynamic> toMap() => serializers.serializeWith(MeasureModel.serializer, this);

  static MeasureModel fromJson(Map<String, dynamic> map) => serializers.deserializeWith(MeasureModel.serializer, map);

  static Serializer<MeasureModel> get serializer => _$measureModelSerializer;
}
