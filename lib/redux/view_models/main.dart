import 'package:redux/redux.dart';
import 'package:tailor_made/rebloc/states/main.dart';

abstract class ViewModel {
  final Store<AppState> store;

  ViewModel(this.store);

  // TODO
  // @override
  // bool operator ==(Object other) => hashCode == other.hashCode;

  // TODO
  // @override
  // int get hashCode => DateTime.now().millisecondsSinceEpoch;
}
