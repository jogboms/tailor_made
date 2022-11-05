part of 'bloc.dart';

@freezed
class ContactsState with _$ContactsState {
  const factory ContactsState({
    required List<ContactModel>? contacts,
    required StateStatus status,
    required bool hasSortFn,
    required ContactsSortType sortFn,
    required List<ContactModel>? searchResults,
    required bool isSearching,
    required String? error,
  }) = _ContactsState;
}
