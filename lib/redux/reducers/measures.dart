import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/actions/measures.dart';
import 'package:tailor_made/redux/states/measures.dart';

MeasuresState reducer(MeasuresState measures, ActionType action) {
  if (action is OnDataMeasureEvent) {
    return measures.copyWith(
      measures: action.payload..sort((a, b) => a.group.compareTo(b.group)),
      grouped: action.grouped,
      status: MeasuresStatus.success,
    );
  }

  if (action is ToggleMeasuresLoading || action is OnInitMeasureEvent) {
    return measures.copyWith(
      status: MeasuresStatus.loading,
    );
  }

  return measures;
}
