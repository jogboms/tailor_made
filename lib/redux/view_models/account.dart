import 'package:redux/redux.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/redux/states/account.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class AccountViewModel extends ViewModel {
  AccountViewModel(Store<ReduxState> store) : super(store);

  AccountModel get account => this.store.state.account.account;

  bool get isLoading => this.store.state.account.status == AccountStatus.loading;

  bool get isSuccess => this.store.state.account.status == AccountStatus.success;

  bool get isFailure => this.store.state.account.status == AccountStatus.failure;
}
