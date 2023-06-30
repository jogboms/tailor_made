part of 'bloc.dart';

@freezed
class ContactsAction with _$ContactsAction, AppAction {
  const factory ContactsAction.init(String userId) = _InitContactsAction;
  const factory ContactsAction.sort(ContactsSortType payload) = _SortContacts;
  const factory ContactsAction.search(String payload) = _SearchContactAction;
  const factory ContactsAction.searchSuccess(List<ContactEntity> payload) = _SearchSuccessContactAction;
  const factory ContactsAction.searchCancel() = _CancelSearchContactAction;
  const factory ContactsAction.searchStart() = _StartSearchContactAction;
}
