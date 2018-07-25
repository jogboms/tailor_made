import 'package:redux/redux.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/states/measures.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class MeasuresViewModel extends ViewModel {
  MeasuresViewModel(Store<ReduxState> store) : super(store);

  MeasuresState get _state => store.state.measures;

  List<MeasureModel> get measures => _state.measures;

  Map<String, List<MeasureModel>> get grouped => _state.grouped;

  bool get isLoading => _state.status == MeasuresStatus.loading;

  bool get isSuccess => _state.status == MeasuresStatus.success;

  bool get isFailure => _state.status == MeasuresStatus.failure;
}
