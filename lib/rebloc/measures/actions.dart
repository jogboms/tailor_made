import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/measure.dart';

class InitMeasuresAction extends Action {
  const InitMeasuresAction(this.userId);

  final String userId;
}

class UpdateMeasureAction extends Action {
  const UpdateMeasureAction(this.payload, this.userId);

  final List<MeasureModel> payload;
  final String userId;
}

class ToggleMeasuresLoading extends Action {
  const ToggleMeasuresLoading();
}
