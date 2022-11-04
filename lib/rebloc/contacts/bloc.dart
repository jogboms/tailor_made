import 'package:built_collection/built_collection.dart';
import 'package:rebloc/rebloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/common/actions.dart';
import 'package:tailor_made/rebloc/common/middleware.dart';
import 'package:tailor_made/rebloc/contacts/actions.dart';
import 'package:tailor_made/rebloc/contacts/sort_type.dart';
import 'package:tailor_made/rebloc/contacts/state.dart';
import 'package:tailor_made/rebloc/extensions.dart';
import 'package:tailor_made/services/contacts/main.dart';

class ContactsBloc extends SimpleBloc<AppState> {
  ContactsBloc(this.contacts);

  final Contacts contacts;

  @override
  Stream<WareContext<AppState>> applyMiddleware(Stream<WareContext<AppState>> input) {
    MergeStream<WareContext<AppState>>(<Stream<WareContext<AppState>>>[
      input.whereAction<SearchContactAction>().switchMap(_makeSearch),
      input.whereAction<InitContactsAction>().switchMap(_onAfterLogin(contacts)),
    ]).untilAction<OnDisposeAction>().listen((WareContext<AppState> context) => context.dispatcher(context.action));

    return input;
  }

  @override
  AppState reducer(AppState state, Action action) {
    final ContactsState contacts = state.contacts;

    if (action is OnDataAction<List<ContactModel>>) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..contacts = contacts
              .rebuild(
                (ContactsStateBuilder b) => b
                  ..contacts = BuiltList<ContactModel>.of(action.payload..sort(_sort(contacts.sortFn))).toBuilder()
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    if (action is StartSearchContactAction) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..contacts = contacts
              .rebuild(
                (ContactsStateBuilder b) => b
                  ..status = StateStatus.loading
                  ..isSearching = true,
              )
              .toBuilder(),
      );
    }

    if (action is SearchSuccessContactAction) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..contacts = contacts
              .rebuild(
                (ContactsStateBuilder b) => b
                  ..searchResults = BuiltList<ContactModel>.of(action.payload..sort(_sort(contacts.sortFn))).toBuilder()
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    if (action is SortContacts) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..contacts = contacts
              .rebuild(
                (ContactsStateBuilder b) => b
                  ..contacts =
                      BuiltList<ContactModel>.of(contacts.contacts!.toList()..sort(_sort(action.payload))).toBuilder()
                  ..hasSortFn = action.payload != SortType.reset
                  ..sortFn = action.payload
                  ..status = StateStatus.success,
              )
              .toBuilder(),
      );
    }

    if (action is CancelSearchContactAction) {
      return state.rebuild(
        (AppStateBuilder b) => b
          ..contacts = contacts
              .rebuild(
                (ContactsStateBuilder b) => b
                  ..status = StateStatus.success
                  ..isSearching = false
                  ..searchResults = BuiltList<ContactModel>(<ContactModel>[]).toBuilder(),
              )
              .toBuilder(),
      );
    }

    return state;
  }
}

Comparator<ContactModel> _sort(SortType sortType) {
  switch (sortType) {
    case SortType.jobs:
      return (ContactModel a, ContactModel b) => b.totalJobs!.compareTo(a.totalJobs!);
    case SortType.names:
      return (ContactModel a, ContactModel b) => a.fullname!.compareTo(b.fullname!);
    case SortType.completed:
      return (ContactModel a, ContactModel b) =>
          (b.totalJobs! - b.pendingJobs!).compareTo(a.totalJobs! - a.pendingJobs!);
    case SortType.pending:
      return (ContactModel a, ContactModel b) => b.pendingJobs!.compareTo(a.pendingJobs!);
    case SortType.recent:
      return (ContactModel a, ContactModel b) => b.createdAt!.compareTo(a.createdAt!);
    case SortType.reset:
    // ignore: no_default_cases
    default:
      return (ContactModel a, ContactModel b) => a.id!.compareTo(b.id!);
  }
}

Middleware _onAfterLogin(Contacts contacts) {
  return (WareContext<AppState> context) {
    return contacts
        .fetchAll((context.action as InitContactsAction).userId)
        .map(OnDataAction<List<ContactModel>>.new)
        .map((OnDataAction<List<ContactModel>> action) => context.copyWith(action));
  };
}

Stream<WareContext<AppState>> _makeSearch(WareContext<AppState> context) {
  return Stream<String>.value((context.action as SearchContactAction).payload)
      .doOnData((_) => context.dispatcher(const StartSearchContactAction()))
      .map<String>((String text) => text.trim())
      .distinct()
      .where((String text) => text.length > 1)
      .debounceTime(const Duration(milliseconds: 750))
      .map(
        (String text) => SearchSuccessContactAction(
          context.state.contacts.contacts!
              .where((ContactModel contact) => contact.fullname!.contains(RegExp(text, caseSensitive: false)))
              .toList(),
        ),
      )
      .takeWhile((SearchSuccessContactAction action) => action is! CancelSearchContactAction)
      .map((SearchSuccessContactAction action) => context.copyWith(action));
}
