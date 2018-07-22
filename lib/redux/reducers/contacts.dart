import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/contacts.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/contacts.dart';

Comparator<ContactModel> _sort(SortType sortType) {
  switch (sortType) {
    case SortType.jobs:
      return (a, b) => b.totalJobs.compareTo(a.totalJobs);
    case SortType.name:
      return (a, b) => a.fullname.compareTo(b.fullname);
    case SortType.pending:
      return (a, b) => b.pendingJobs.compareTo(a.pendingJobs);
    case SortType.recent:
      return (a, b) => b.createdAt.compareTo(a.createdAt);
    case SortType.reset:
    default:
      return (a, b) => a.id.compareTo(b.id);
  }
}

ContactsState reducer(ContactsState contacts, ActionType action) {
  if (action is OnDataContactEvent) {
    return contacts.copyWith(
      contacts: List<ContactModel>.of(action.payload)
        ..sort(_sort(contacts.sortFn)),
      status: ContactsStatus.success,
    );
  }

  if (action is StartSearchContactEvent) {
    return contacts.copyWith(
      status: ContactsStatus.loading,
      isSearching: true,
    );
  }

  if (action is SearchSuccessContactEvent) {
    return contacts.copyWith(
      searchResults: List<ContactModel>.of(action.payload)
        ..sort(_sort(contacts.sortFn)),
      status: ContactsStatus.success,
    );
  }

  if (action is SortContacts) {
    return contacts.copyWith(
      contacts: List<ContactModel>.of(contacts.contacts)
        ..sort(_sort(action.payload)),
      hasSortFn: action.payload != SortType.reset,
      sortFn: action.payload,
      status: ContactsStatus.success,
    );
  }

  if (action is CancelSearchContactEvent) {
    return contacts.copyWith(
      status: ContactsStatus.success,
      isSearching: false,
      searchResults: [],
    );
  }

  return contacts;
}
