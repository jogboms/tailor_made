import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

part 'actions.dart';
part 'bloc.freezed.dart';
part 'state.dart';

class ContactsBloc extends SimpleBloc<AppState> {
  ContactsBloc(this.contacts);

  final Contacts contacts;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream<WareContext<AppState>>(<Stream<WareContext<AppState>>>[
      input.whereAction<_SearchContactAction>().switchMap(_makeSearch),
      input.whereAction<_InitContactsAction>().switchMap(_onAfterLogin(contacts)),
    ]).untilAction<OnDisposeAction>().listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final ContactsState contacts = state.contacts;

    if (action is OnDataAction<List<ContactModel>>) {
      return state.copyWith(
        contacts: contacts.copyWith(
          contacts: List<ContactModel>.of(action.payload..sort(_sort(contacts.sortFn))),
          status: StateStatus.success,
        ),
      );
    }

    if (action is _StartSearchContactAction) {
      return state.copyWith(
        contacts: contacts.copyWith(
          status: StateStatus.loading,
          isSearching: true,
        ),
      );
    }

    if (action is _SearchSuccessContactAction) {
      return state.copyWith(
        contacts: contacts.copyWith(
          searchResults: List<ContactModel>.of(action.payload..sort(_sort(contacts.sortFn))),
          status: StateStatus.success,
        ),
      );
    }

    if (action is _SortContacts) {
      return state.copyWith(
        contacts: contacts.copyWith(
          contacts: List<ContactModel>.of(contacts.contacts!.toList()..sort(_sort(action.payload))),
          hasSortFn: action.payload != ContactsSortType.reset,
          sortFn: action.payload,
          status: StateStatus.success,
        ),
      );
    }

    if (action is _CancelSearchContactAction) {
      return state.copyWith(
        contacts: contacts.copyWith(
          status: StateStatus.success,
          isSearching: false,
          searchResults: List<ContactModel>.of(<ContactModel>[]),
        ),
      );
    }

    return state;
  }
}

Comparator<ContactModel> _sort(ContactsSortType sortType) {
  switch (sortType) {
    case ContactsSortType.jobs:
      return (ContactModel a, ContactModel b) => b.totalJobs.compareTo(a.totalJobs);
    case ContactsSortType.names:
      return (ContactModel a, ContactModel b) => a.fullname.compareTo(b.fullname);
    case ContactsSortType.completed:
      return (ContactModel a, ContactModel b) => (b.totalJobs - b.pendingJobs).compareTo(a.totalJobs - a.pendingJobs);
    case ContactsSortType.pending:
      return (ContactModel a, ContactModel b) => b.pendingJobs.compareTo(a.pendingJobs);
    case ContactsSortType.recent:
      return (ContactModel a, ContactModel b) => b.createdAt.compareTo(a.createdAt);
    case ContactsSortType.reset:
      return (ContactModel a, ContactModel b) => a.id.compareTo(b.id);
  }
}

Middleware _onAfterLogin(Contacts contacts) {
  return (WareContext<AppState> context) {
    return contacts
        .fetchAll((context.action as _InitContactsAction).userId)
        .map(OnDataAction<List<ContactModel>>.new)
        .map((OnDataAction<List<ContactModel>> action) => context.copyWith(action));
  };
}

Stream<WareContext<AppState>> _makeSearch(WareContext<AppState> context) {
  return Stream<String>.value((context.action as _SearchContactAction).payload)
      .doOnData((_) => context.dispatcher(const ContactsAction.searchStart()))
      .map<String>((String text) => text.trim())
      .distinct()
      .where((String text) => text.length > 1)
      .debounceTime(const Duration(milliseconds: 750))
      .map(
        (String text) => ContactsAction.searchSuccess(
          context.state.contacts.contacts!
              .where((ContactModel contact) => contact.fullname.contains(RegExp(text, caseSensitive: false)))
              .toList(),
        ),
      )
      .takeWhile((ContactsAction action) => action is! _CancelSearchContactAction)
      .map((ContactsAction action) => context.copyWith(action));
}
