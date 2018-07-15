import 'package:redux/redux.dart';
import 'package:tailor_made/models/stats.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/states/stats.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class StatsViewModel extends ViewModel {
  StatsViewModel(Store<ReduxState> store) : super(store);

  StatsModel get stats => this.store.state.stats.stats;

  bool get isLoading => this.store.state.stats.status == StatsStatus.loading;

  bool get isSuccess => this.store.state.stats.status == StatsStatus.success;

  bool get isFailure => this.store.state.stats.status == StatsStatus.failure;
}
