import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

abstract class MeasureGroup with EquatableMixin implements Comparable<MeasureGroup> {
  const MeasureGroup._(this.displayName);

  static const MeasureGroup empty = _MeasureGroup('');
  static const MeasureGroup blouse = _MeasureGroup('Blouse');
  static const MeasureGroup trouser = _MeasureGroup('Trouser');
  static const MeasureGroup skirts = _MeasureGroup('Skirts');
  static const MeasureGroup gown = _MeasureGroup('Gown');

  static MeasureGroup valueOf(String name) =>
      values.firstWhereOrNull((MeasureGroup value) => value.displayName.toLowerCase() == name.toLowerCase()) ??
      _MeasureGroup(name);

  static const List<MeasureGroup> values = <MeasureGroup>[empty, blouse, trouser, skirts, gown];

  final String displayName;

  @override
  List<String> get props => <String>[displayName];

  @override
  String toString() => displayName;
}

class _MeasureGroup extends MeasureGroup {
  const _MeasureGroup(super.displayName) : super._();

  @override
  int compareTo(MeasureGroup other) => displayName.compareTo(other.displayName);
}
