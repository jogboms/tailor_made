import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
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
}
