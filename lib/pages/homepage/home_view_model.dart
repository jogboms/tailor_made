import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/stats.dart';
import 'package:tailor_made/redux/view_models/stats.dart';

class HomeViewModel extends StatsViewModel {
  HomeViewModel(store) : super(store);

  get contacts => store.state.contacts.contacts;

  bool get isLoading {
    return this.store.state.stats.status == StatsStatus.loading || this.store.state.contacts.status == ContactsStatus.loading;
  }
}
