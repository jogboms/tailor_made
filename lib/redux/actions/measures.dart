import 'package:meta/meta.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/redux/actions/main.dart';

class OnDataMeasureEvent extends ActionType<List<MeasureModel>> {
  Map<String, List<MeasureModel>> grouped;

  OnDataMeasureEvent({
    @required List<MeasureModel> payload,
    @required this.grouped,
  }) : super(payload: payload);
}

class OnInitMeasureEvent extends ActionType<List<MeasureModel>> {
  OnInitMeasureEvent({
    @required List<MeasureModel> payload,
  }) : super(payload: payload);
}

class ToggleMeasuresLoading extends ActionType<void> {}
