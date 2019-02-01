import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/measure.dart';

class OnDataMeasureAction extends Action {
  const OnDataMeasureAction({
    @required this.payload,
    @required this.grouped,
  });

  final List<MeasureModel> payload;
  final Map<String, List<MeasureModel>> grouped;
}

class OnInitMeasureAction extends Action {
  const OnInitMeasureAction({
    @required this.payload,
  });

  final List<MeasureModel> payload;
}

class ToggleMeasuresLoading extends Action {
  const ToggleMeasuresLoading();
}
