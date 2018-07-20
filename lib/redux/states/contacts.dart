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

  const ContactsState({
    @required this.contacts,
    @required this.status,
    @required this.message,
    @required this.hasSortFn,
    @required this.sortFn,
  });

  const ContactsState.initialState()
      : contacts = null,
        status = ContactsStatus.loading,
        hasSortFn = false,
        sortFn = SortType.reset,
        message = '';

  ContactsState copyWith({
    List<ContactModel> contacts,
    ContactsStatus status,
    String message,
    bool hasSortFn,
    SortType sortFn,
  }) {
    return new ContactsState(
      contacts: contacts ?? this.contacts,
      status: status ?? this.status,
      message: message ?? this.message,
      hasSortFn: hasSortFn ?? this.hasSortFn,
      sortFn: sortFn ?? this.sortFn,
    );
  }
}
