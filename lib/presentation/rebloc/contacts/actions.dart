part of 'bloc.dart';

@freezed
class ContactsAction with _$ContactsAction, AppAction {
  const factory ContactsAction.init(String? userId) = InitContactsAction;
  const factory ContactsAction.sort(ContactsSortType payload) = SortContacts;
  const factory ContactsAction.search(String payload) = SearchContactAction;
  const factory ContactsAction.searchSuccess(List<ContactModel> payload) = SearchSuccessContactAction;
  const factory ContactsAction.searchCancel() = CancelSearchContactAction;
  const factory ContactsAction.searchStart() = StartSearchContactAction;
}
