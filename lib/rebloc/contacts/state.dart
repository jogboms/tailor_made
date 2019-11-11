import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/contacts/actions.dart';

@immutable
class ContactsState {
  const ContactsState({
    @required this.contacts,
    @required this.status,
    @required this.message,
    @required this.hasSortFn,
    @required this.sortFn,
    @required this.searchResults,
    @required this.isSearching,
    this.error,
  });

  const ContactsState.initialState()
      : contacts = null,
        status = StateStatus.loading,
        hasSortFn = true,
        sortFn = SortType.name,
        searchResults = null,
        isSearching = false,
        message = '',
        error = null;

  final List<ContactModel> contacts;
  final StateStatus status;
  final String message;
  final bool hasSortFn;
  final SortType sortFn;
  final List<ContactModel> searchResults;
  final bool isSearching;
  final dynamic error;

  ContactsState copyWith({
    List<ContactModel> contacts,
    StateStatus status,
    String message,
    bool hasSortFn,
    SortType sortFn,
    List<ContactModel> searchResults,
    bool isSearching,
    dynamic error,
  }) {
    return ContactsState(
      contacts: contacts ?? this.contacts,
      status: status ?? this.status,
      message: message ?? this.message,
      hasSortFn: hasSortFn ?? this.hasSortFn,
      sortFn: sortFn ?? this.sortFn,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => """
Contacts: $contacts,
HasSortFn: $hasSortFn,
SortFn: $sortFn,
SearchResults: $searchResults,
IsSearching: $isSearching
    """;
}
