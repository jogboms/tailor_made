import 'package:meta/meta.dart';
import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/measure.dart';

class InitMeasuresAction extends Action {
  const InitMeasuresAction();
}

class UpdateMeasureAction extends Action {
  const UpdateMeasureAction({@required this.payload});

  final List<MeasureModel> payload;
}

class ToggleMeasuresLoading extends Action {
  const ToggleMeasuresLoading();
}
