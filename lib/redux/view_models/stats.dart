import 'package:redux/redux.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/states/stats.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class StatsViewModel extends ViewModel {
  StatsViewModel(Store<ReduxState> store) : super(store);

  StatsModel get stats => store.state.stats.stats;

  bool get isLoading => store.state.stats.status == StatsStatus.loading;

  bool get isSuccess => store.state.stats.status == StatsStatus.success;

  bool get isFailure => store.state.stats.status == StatsStatus.failure;
}
