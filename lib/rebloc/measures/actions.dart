import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/measure.dart';

class InitMeasuresAction extends Action {
  const InitMeasuresAction();
}

class OnDataMeasureAction extends Action {
  const OnDataMeasureAction({@required this.payload, @required this.grouped});

  final List<MeasureModel> payload;
  final Map<String, List<MeasureModel>> grouped;
}

class UpdateMeasureAction extends Action {
  const UpdateMeasureAction({@required this.payload});

  final List<MeasureModel> payload;
}

class ToggleMeasuresLoading extends Action {
  const ToggleMeasuresLoading();
}
