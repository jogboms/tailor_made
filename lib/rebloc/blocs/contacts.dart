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
  Stream<WareContext<AppState>> _onAfterLogin(
    WareContext<AppState> context,
  ) {
    return CloudDb.contacts
        .snapshots()
        .map(
          (snapshot) => snapshot.documents
              .where((doc) => doc.data.containsKey('fullname'))
              .map((item) => ContactModel.fromDoc(item))
              .toList(),
        )
        .map((contacts) => OnDataContactAction(payload: contacts))
        .map((action) => context.copyWith(action))
        .takeWhile((_) => _.action is! OnDisposeAction);
  }

  Stream<WareContext<AppState>> _makeSearch(
    WareContext<AppState> context,
  ) {
    return Observable<String>.just(
            (context.action as SearchContactAction).payload)
        .map<String>((String text) => text.trim())
        .distinct()
        .where((text) => text.length > 1)
        .debounce(const Duration(milliseconds: 750))
        .switchMap<Action>(
          (text) => ConcatStream<Action>(
                [
                  Stream.fromIterable([const StartSearchContactAction()]),
                  Observable.timer(
                    SearchSuccessContactAction(
                      payload: context.state.contacts.contacts.where(
                        (contact) {
                          return contact.fullname.contains(
                            RegExp(r'' + text + '', caseSensitive: false),
                          );
                        },
                      ).toList(),
                    ),
                    const Duration(seconds: 1),
                  )
                ],
              ).takeWhile((action) => action is! CancelSearchContactAction),
        )
        .map((action) => context.copyWith(action));
  }

  @override
  Stream<WareContext<AppState>> applyMiddleware(
    Stream<WareContext<AppState>> input,
  ) {
    MergeStream([
      input.where((_) => _.action is SearchContactAction).asyncExpand(
            _makeSearch,
          ),
      input.where((_) => _.action is OnLoginAction).asyncExpand(_onAfterLogin),
    ]).listen(
      (context) => context.dispatcher(context.action),
    );

    return input;
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
