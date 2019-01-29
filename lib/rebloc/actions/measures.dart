import 'package:rebloc/rebloc.dart';

class MeasuresInitAction extends Action {
  const MeasuresInitAction();
}

class MeasuresUpdateAction extends Action {
  const MeasuresUpdateAction(this.measures);

  final dynamic measures;
}
