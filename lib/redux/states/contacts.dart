import 'package:flutter/foundation.dart';
import 'package:tailor_made/models/contact.dart';

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

  const ContactsState({this.contacts, this.status, this.message});

  const ContactsState.initialState()
      : contacts = null,
        status = ContactsStatus.loading,
        message = '';

  ContactsState copyWith({
    List<ContactModel> contacts,
    ContactsStatus status,
    String message,
  }) {
    return new ContactsState(
      contacts: contacts ?? this.contacts,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
