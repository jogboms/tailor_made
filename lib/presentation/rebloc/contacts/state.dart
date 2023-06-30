part of 'bloc.dart';

@freezed
class ContactsState with _$ContactsState {
  const factory ContactsState({
    required List<ContactEntity>? contacts,
    required StateStatus status,
    required bool hasSortFn,
    required ContactsSortType sortFn,
    required List<ContactEntity>? searchResults,
    required bool isSearching,
    required String? error,
  }) = _ContactsState;
}
