import 'package:redux/redux.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/states/stats.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class StatsViewModel extends ViewModel {
  StatsViewModel(Store<ReduxState> store) : super(store);

  StatsState get _state => store.state.stats;

  StatsModel get stats => _state.stats;

  bool get isLoading => _state.status == StatsStatus.loading;

  bool get isSuccess => _state.status == StatsStatus.success;

  bool get isFailure => _state.status == StatsStatus.failure;
}
