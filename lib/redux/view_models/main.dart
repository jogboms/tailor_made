import 'package:redux/redux.dart';
import 'package:tailor_made/redux/states/main.dart';

abstract class ViewModel {
  final Store<ReduxState> store;

  ViewModel(this.store);
}
