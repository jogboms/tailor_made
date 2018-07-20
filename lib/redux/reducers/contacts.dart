import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/redux/actions/contacts.dart';
import 'package:tailor_made/redux/actions/main.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/redux/states/main.dart';

List<ContactModel> _sort(List<ContactModel> _contacts, SortType sortType) {
  switch (sortType) {
    case SortType.active:
      _contacts.sort((a, b) => b.totalJobs.compareTo(a.totalJobs));
      break;
    case SortType.name:
      _contacts.sort((a, b) => a.fullname.compareTo(b.fullname));
      break;
    case SortType.pending:
      _contacts.sort((a, b) => b.pendingJobs.compareTo(a.pendingJobs));
      break;
    case SortType.recent:
      _contacts.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      break;
    case SortType.reset:
    default:
      _contacts.sort((a, b) => a.id.compareTo(b.id));
      break;
  }
  return _contacts;
}

ContactsState reducer(ReduxState state, ActionType action) {
  final ContactsState contacts = state.contacts;

  switch (action.type) {
    case ReduxActions.initContacts:
    case ReduxActions.onDataEventContact:
      return contacts.copyWith(
        contacts: _sort(action.payload, contacts.sortFn),
        status: ContactsStatus.success,
      );

    case ReduxActions.sortContacts:
      final _contacts = contacts.contacts;
      return contacts.copyWith(
        contacts: _sort(_contacts, action.payload),
        hasSortFn: action.payload != SortType.reset,
        sortFn: action.payload,
        status: ContactsStatus.success,
      );

    // case ReduxActions.addContact:
    //   List<ContactModel> _contacts = new List.from(contacts.contacts)..add(action.payload);
    //   return contacts.copyWith(contacts: _contacts);

    // case ReduxActions.removeContact:
    //   List<ContactModel> _contacts = contacts.contacts
    //       .where(
    //         (contact) => contact.id != action.payload.id,
    //       )
    //       .toList();
    //   return contacts.copyWith(contacts: _contacts);

    default:
      return contacts;
  }
}
