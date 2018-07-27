import 'package:redux/redux.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/redux/states/account.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class AccountViewModel extends ViewModel {
  AccountViewModel(Store<ReduxState> store) : super(store);

  AccountState get _state => store.state.account;

  AccountModel get account => _state.account;

  bool get isLoading => _state.status == AccountStatus.loading;

  bool get isSuccess => _state.status == AccountStatus.success;

  bool get isFailure => _state.status == AccountStatus.failure;
}
