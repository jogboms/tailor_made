import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import '../entities.dart';

part 'measure.freezed.dart';
part 'measure.g.dart';

List<MeasureModel> createDefaultMeasures() {
  const Uuid uuid = Uuid();
  final DateTime now = DateTime.now();

  return <MeasureModel>[
    MeasureModel(
      id: uuid.v4(),
      name: 'Arm Hole',
      group: MeasureModelType.blouse,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Shoulder',
      group: MeasureModelType.blouse,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Bust',
      group: MeasureModelType.blouse,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Bust Point',
      group: MeasureModelType.blouse,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Shoulder - Bust Point',
      group: MeasureModelType.blouse,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Shoulder - Under Bust',
      group: MeasureModelType.blouse,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Shoulder - Waist',
      group: MeasureModelType.blouse,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Length',
      group: MeasureModelType.trouser,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Waist',
      group: MeasureModelType.trouser,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Crouch',
      group: MeasureModelType.trouser,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Thigh',
      group: MeasureModelType.trouser,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Body Rise',
      group: MeasureModelType.trouser,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Width',
      group: MeasureModelType.trouser,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Hip',
      group: MeasureModelType.trouser,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Full Length',
      group: MeasureModelType.skirts,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Short Length',
      group: MeasureModelType.skirts,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Knee Length',
      group: MeasureModelType.skirts,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Hip',
      group: MeasureModelType.skirts,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Waist',
      group: MeasureModelType.gown,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Long Length',
      group: MeasureModelType.gown,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Short Length',
      group: MeasureModelType.gown,
      createdAt: now,
    ),
    MeasureModel(
      id: uuid.v4(),
      name: 'Knee Length',
      group: MeasureModelType.gown,
      createdAt: now,
    ),
  ];
}

class MeasureModelType {
  static String blouse = 'Blouse';
  static String trouser = 'Trouser';
  static String skirts = 'Skirts';
  static String gown = 'Gown';
}

@freezed
class MeasureModel with _$MeasureModel {
  const factory MeasureModel({
    @JsonKey(
      includeFromJson: false,
      includeToJson: false,
    )
    Reference? reference,
    required String id,
    required String name,
    @Default(0.0) double value,
    @Default('In') String unit,
    required String group,
    required DateTime createdAt,
  }) = _MeasureModel;

  factory MeasureModel.fromJson(Map<String, Object?> json) => _$MeasureModelFromJson(json);
}
