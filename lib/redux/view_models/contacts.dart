import 'package:redux/redux.dart';
import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class ContactsViewModel extends ViewModel {
  ContactsViewModel(Store<ReduxState> store) : super(store);

  List<ContactModel> get contacts {
    return this.store.state.contacts.contacts;
  }

  bool get isLoading => this.store.state.contacts.status == ContactsStatus.loading;

  bool get isSuccess => this.store.state.contacts.status == ContactsStatus.success;

  bool get isFailure => this.store.state.contacts.status == ContactsStatus.failure;
}
