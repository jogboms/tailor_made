import 'package:tailor_made/pages/contacts/models/contact.model.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/main.dart';

ContactsState reducer(ReduxState state, ActionType action) {
  final ContactsState contacts = state.contacts;

  switch (action.type) {
    case ReduxActions.initContacts:
      return contacts.copyWith(contacts: action.payload);

    case ReduxActions.addContact:
      List<ContactModel> _contacts = new List.from(contacts.contacts)..add(action.payload);
      return contacts.copyWith(contacts: _contacts);

    case ReduxActions.removeContact:
      List<ContactModel> _contacts = contacts.contacts
          .where(
            (contact) => contact.documentID != action.payload.documentID,
          )
          .toList();
      return contacts.copyWith(contacts: _contacts);

    default:
      return contacts;
  }
}
