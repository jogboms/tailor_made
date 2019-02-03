import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/actions/common.dart';
import 'package:tailor_made/rebloc/actions/contacts.dart';
import 'package:tailor_made/rebloc/states/contacts.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/services/cloud_db.dart';

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
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    return input.map(
      (context) {
        final _action = context.action;

        if (_action is SearchContactAction) {
          Observable<String>.just(_action.payload)
              .map<String>((String text) => text.trim())
              .distinct()
              .where((text) => text.length > 1)
              .debounce(const Duration(milliseconds: 750))
              .switchMap<Action>(
                (text) => Observable.concat([
                      Observable.just(StartSearchContactAction()),
                      Observable.timer(
                        _doSearch(
                          context.state.contacts.contacts,
                          text,
                        ),
                        Duration(seconds: 1),
                      )
                    ]).takeUntil<dynamic>(
                      input.where(
                          (action) => action is CancelSearchContactAction),
                    ),
              )
              .listen((action) => context.dispatcher(action));
        }

        if (_action is OnInitAction) {
          CloudDb.contacts
              .snapshots()
              .map(
                (snapshot) => snapshot.documents
                    .where((doc) => doc.data.containsKey('fullname'))
                    .map((item) => ContactModel.fromDoc(item))
                    .toList(),
              )
              .takeWhile((action) => action is! OnDisposeAction)
              .listen((contacts) => context.dispatcher(
                    OnDataContactAction(payload: contacts),
                  ));
        }

        return context;
      },
    );
  }

  @override
  AppState reducer(AppState state, Action action) {
    final _contacts = state.contacts;

    if (action is OnDataContactAction) {
      return state.copyWith(
        contacts: _contacts.copyWith(
          contacts: List<ContactModel>.of(action.payload)
            ..sort(_sort(_contacts.sortFn)),
          status: ContactsStatus.success,
        ),
      );
    }

    if (action is StartSearchContactAction) {
      return state.copyWith(
        contacts: _contacts.copyWith(
          status: ContactsStatus.loading,
          isSearching: true,
        ),
      );
    }

    if (action is SearchSuccessContactAction) {
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

    if (action is CancelSearchContactAction) {
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

SearchSuccessContactAction _doSearch(List<ContactModel> contacts, String text) {
  return SearchSuccessContactAction(
    payload: contacts
        .where((contact) => contact.fullname.contains(
              RegExp(r'' + text + '', caseSensitive: false),
            ))
        .toList(),
  );
}
