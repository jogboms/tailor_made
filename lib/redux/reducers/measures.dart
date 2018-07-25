import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/actions/measures.dart';
import 'package:tailor_made/redux/states/measures.dart';

MeasuresState reducer(MeasuresState measures, ActionType action) {
  if (action is OnDataMeasureEvent) {
    return measures.copyWith(
      measures: action.payload,
      grouped: action.grouped,
      status: MeasuresStatus.success,
    );
  }

  if (action is ToggleMeasuresLoading) {
    return measures.copyWith(
      status: MeasuresStatus.success,
    );
  }

  return measures;
}
