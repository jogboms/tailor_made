import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';

sealed class BaseMeasureEntity {
  static final Iterable<BaseMeasureEntity> defaults = <BaseMeasureEntity>{
    const DefaultMeasureEntity(name: 'Arm Hole', group: MeasureGroup.blouse),
    const DefaultMeasureEntity(name: 'Shoulder', group: MeasureGroup.blouse),
    const DefaultMeasureEntity(name: 'Bust', group: MeasureGroup.blouse),
    const DefaultMeasureEntity(name: 'Bust Point', group: MeasureGroup.blouse),
    const DefaultMeasureEntity(name: 'Shoulder - Bust Point', group: MeasureGroup.blouse),
    const DefaultMeasureEntity(name: 'Shoulder - Under Bust', group: MeasureGroup.blouse),
    const DefaultMeasureEntity(name: 'Shoulder - Waist', group: MeasureGroup.blouse),
    const DefaultMeasureEntity(name: 'Length', group: MeasureGroup.trouser),
    const DefaultMeasureEntity(name: 'Waist', group: MeasureGroup.trouser),
    const DefaultMeasureEntity(name: 'Crouch', group: MeasureGroup.trouser),
    const DefaultMeasureEntity(name: 'Thigh', group: MeasureGroup.trouser),
    const DefaultMeasureEntity(name: 'Body Rise', group: MeasureGroup.trouser),
    const DefaultMeasureEntity(name: 'Width', group: MeasureGroup.trouser),
    const DefaultMeasureEntity(name: 'Hip', group: MeasureGroup.trouser),
    const DefaultMeasureEntity(name: 'Full Length', group: MeasureGroup.skirts),
    const DefaultMeasureEntity(name: 'Short Length', group: MeasureGroup.skirts),
    const DefaultMeasureEntity(name: 'Knee Length', group: MeasureGroup.skirts),
    const DefaultMeasureEntity(name: 'Hip', group: MeasureGroup.skirts),
    const DefaultMeasureEntity(name: 'Waist', group: MeasureGroup.gown),
    const DefaultMeasureEntity(name: 'Long Length', group: MeasureGroup.gown),
    const DefaultMeasureEntity(name: 'Short Length', group: MeasureGroup.gown),
    const DefaultMeasureEntity(name: 'Knee Length', group: MeasureGroup.gown),
  };

  String get name;

  String get unit;

  MeasureGroup get group;
}

class MeasureEntity with EquatableMixin implements BaseMeasureEntity {
  const MeasureEntity({
    required this.reference,
    required this.id,
    required this.name,
    this.value = 0.0,
    this.unit = 'In',
    required this.group,
    required this.createdAt,
  });

  final ReferenceEntity reference;
  final String id;
  @override
  final String name;
  final double value;
  @override
  final String unit;
  @override
  final MeasureGroup group;
  final DateTime createdAt;

  @override
  List<Object> get props => <Object>[reference, id, name, value, unit, group, createdAt];

  MeasureEntity copyWith({
    ReferenceEntity? reference,
    String? id,
    String? name,
    double? value,
    String? unit,
    MeasureGroup? group,
    DateTime? createdAt,
  }) {
    return MeasureEntity(
      reference: reference ?? this.reference,
      id: id ?? this.id,
      name: name ?? this.name,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      group: group ?? this.group,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class DefaultMeasureEntity with EquatableMixin implements BaseMeasureEntity {
  const DefaultMeasureEntity({
    required this.name,
    this.value = 0.0,
    this.unit = 'In',
    required this.group,
  });

  @override
  final String name;
  final double value;
  @override
  final String unit;
  @override
  final MeasureGroup group;

  @override
  List<Object> get props => <Object>[name, value, unit, group];

  DefaultMeasureEntity copyWith({
    String? name,
    double? value,
    String? unit,
    MeasureGroup? group,
  }) {
    return DefaultMeasureEntity(
      name: name ?? this.name,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      group: group ?? this.group,
    );
  }
}
