import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/contacts.dart';

enum ContactsStatus {
  loading,
  success,
  failure,
}

@immutable
class ContactsState {
  final List<ContactModel> contacts;
  final ContactsStatus status;
  final String message;
  final bool hasSortFn;
  final SortType sortFn;
  final List<ContactModel> searchResults;
  final bool isSearching;

  const ContactsState({
    @required this.contacts,
    @required this.status,
    @required this.message,
    @required this.hasSortFn,
    @required this.sortFn,
    @required this.searchResults,
    @required this.isSearching,
  });

  const ContactsState.initialState()
      : contacts = null,
        status = ContactsStatus.loading,
        hasSortFn = true,
        sortFn = SortType.name,
        searchResults = null,
        isSearching = false,
        message = '';

  ContactsState copyWith({
    List<ContactModel> contacts,
    ContactsStatus status,
    String message,
    bool hasSortFn,
    SortType sortFn,
    List<ContactModel> searchResults,
    bool isSearching,
  }) {
    return new ContactsState(
      contacts: contacts ?? this.contacts,
      status: status ?? this.status,
      message: message ?? this.message,
      hasSortFn: hasSortFn ?? this.hasSortFn,
      sortFn: sortFn ?? this.sortFn,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}
