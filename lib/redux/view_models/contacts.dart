import 'package:redux/redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/contacts.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class ContactsViewModel extends ViewModel {
  String contactID;

  ContactsViewModel(Store<ReduxState> store) : super(store);

  ContactsState get _state => store.state.contacts;

  List<ContactModel> get contacts {
    return isSearching ? _state.searchResults : _state.contacts;
  }

  ContactModel get selected {
    if (contactID != null) {
      return _state.contacts.firstWhere(
        (_) => _.id == contactID,
      );
    }
    return null;
  }

  bool get isLoading => _state.status == ContactsStatus.loading;

  bool get isSuccess => _state.status == ContactsStatus.success;

  bool get isFailure => _state.status == ContactsStatus.failure;

  SortType get sortFn => _state.sortFn;

  bool get hasSortFn => _state.hasSortFn;

  bool get isSearching => _state.isSearching;

  void setSortFn(SortType type) => store.dispatch(SortContacts(payload: type));

  void search(String term) => store.dispatch(SearchContactEvent(payload: term));

  void cancelSearch() => store.dispatch(SearchCancelEvent());
}
