import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/measure.dart';

class OnDataMeasureEvent extends Action {
  const OnDataMeasureEvent({
    @required this.payload,
    @required this.grouped,
  });

  final List<MeasureModel> payload;
  final Map<String, List<MeasureModel>> grouped;
}

class OnInitMeasureEvent extends Action {
  const OnInitMeasureEvent({
    @required this.payload,
  });

  final List<MeasureModel> payload;
}

class ToggleMeasuresLoading extends Action {
  const ToggleMeasuresLoading();
}
