import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/account.dart';
import 'package:tailor_made/redux/states/account.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/stats.dart';
import 'package:tailor_made/redux/view_models/stats.dart';

class HomeViewModel extends StatsViewModel {
  HomeViewModel(store) : super(store);

  AccountModel get account => store.state.account.account;

  List<ContactModel> get contacts => store.state.contacts.contacts;

  bool get isLoading {
    return this.store.state.stats.status == StatsStatus.loading ||
        this.store.state.contacts.status == ContactsStatus.loading ||
        this.store.state.account.status == AccountStatus.loading;
  }

  bool get hasSkipedPremium => store.state.account.hasSkipedPremium == true;

  bool get isDisabled => account.status == AccountModelStatus.disabled;

  bool get isWarning => account.status == AccountModelStatus.warning;

  bool get isPending => account.status == AccountModelStatus.pending;

  onPremiumSignUp() => this.store.dispatch(OnPremiumSignUp(payload: account));

  onSkipedPremium() => this.store.dispatch(OnSkipedPremium());
}
