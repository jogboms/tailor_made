import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/app_state.dart';

part 'state.g.dart';

abstract class MeasuresState implements Built<MeasuresState, MeasuresStateBuilder> {
  factory MeasuresState([MeasuresState updates(MeasuresStateBuilder b)]) = _$MeasuresState;

  factory MeasuresState.initialState() => _$MeasuresState(
        (MeasuresStateBuilder b) => b
          ..measures = null
          ..grouped = null
          ..status = StateStatus.loading
          ..hasSkipedPremium = false
          ..message = ''
          ..error = null,
      );

  MeasuresState._();

  @nullable
  BuiltList<MeasureModel> get measures;

  @nullable
  Map<String, List<MeasureModel>> get grouped;

  bool get hasSkipedPremium;

  StateStatus get status;

  String get message;

  @nullable
  String get error;

  static Serializer<MeasuresState> get serializer => _$measuresStateSerializer;
}
