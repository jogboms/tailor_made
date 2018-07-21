import 'package:redux/redux.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/account.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/account.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/states/stats.dart';
import 'package:tailor_made/redux/view_models/stats.dart';

class HomeViewModel extends StatsViewModel {
  HomeViewModel(Store<ReduxState> store) : super(store);

  AccountModel get account => store.state.account.account;

  List<ContactModel> get contacts => store.state.contacts.contacts;

  @override
  bool get isLoading {
    return store.state.stats.status == StatsStatus.loading ||
        store.state.contacts.status == ContactsStatus.loading ||
        store.state.account.status == AccountStatus.loading;
  }

  bool get hasSkipedPremium => store.state.account.hasSkipedPremium == true;

  bool get isDisabled => account.status == AccountModelStatus.disabled;

  bool get isWarning => account.status == AccountModelStatus.warning;

  bool get isPending => account.status == AccountModelStatus.pending;

  void onPremiumSignUp() => store.dispatch(OnPremiumSignUp(payload: account));

  void onReadNotice() => store.dispatch(OnReadNotice(payload: account));

  void onSkipedPremium() => store.dispatch(OnSkipedPremium());

  void logout() => store.dispatch(OnLogoutEvent());
}
