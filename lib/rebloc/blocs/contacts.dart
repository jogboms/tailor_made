import 'package:rebloc/rebloc.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/actions/contacts.dart';
import 'package:tailor_made/rebloc/states/contacts.dart';
import 'package:tailor_made/rebloc/states/main.dart';

Comparator<ContactModel> _sort(SortType sortType) {
  switch (sortType) {
    case SortType.jobs:
      return (a, b) => b.totalJobs.compareTo(a.totalJobs);
    case SortType.name:
      return (a, b) => a.fullname.compareTo(b.fullname);
    case SortType.completed:
      return (a, b) =>
          (b.totalJobs - b.pendingJobs).compareTo(a.totalJobs - a.pendingJobs);
    case SortType.pending:
      return (a, b) => b.pendingJobs.compareTo(a.pendingJobs);
    case SortType.recent:
      return (a, b) => b.createdAt.compareTo(a.createdAt);
    case SortType.reset:
    default:
      return (a, b) => a.id.compareTo(b.id);
  }
}

class ContactsBloc extends SimpleBloc<AppState> {
  @override
  AppState reducer(AppState state, Action action) {
    final _contacts = state.contacts;

    if (action is OnDataContactEvent) {
      return state.copyWith(
        contacts: _contacts.copyWith(
          contacts: List<ContactModel>.of(action.payload)
            ..sort(_sort(_contacts.sortFn)),
          status: ContactsStatus.success,
        ),
      );
    }

    if (action is StartSearchContactEvent) {
      return state.copyWith(
        contacts: _contacts.copyWith(
          status: ContactsStatus.loading,
          isSearching: true,
        ),
      );
    }

    if (action is SearchSuccessContactEvent) {
      return state.copyWith(
        contacts: _contacts.copyWith(
          searchResults: List<ContactModel>.of(action.payload)
            ..sort(_sort(_contacts.sortFn)),
          status: ContactsStatus.success,
        ),
      );
    }

    if (action is SortContacts) {
      return state.copyWith(
        contacts: _contacts.copyWith(
          contacts: List<ContactModel>.of(_contacts.contacts)
            ..sort(_sort(action.payload)),
          hasSortFn: action.payload != SortType.reset,
          sortFn: action.payload,
          status: ContactsStatus.success,
        ),
      );
    }

    if (action is CancelSearchContactEvent) {
      return state.copyWith(
        contacts: _contacts.copyWith(
          status: ContactsStatus.success,
          isSearching: false,
          searchResults: [],
        ),
      );
    }

    return state;
  }
}
