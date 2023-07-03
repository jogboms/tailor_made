import 'dart:async';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';
import '../../../utils.dart';

part 'filtered_contacts_state_provider.g.dart';

@Riverpod(dependencies: <Object>[contacts])
Future<FilteredContactsState> filteredContacts(FilteredContactsRef ref) async {
  final List<ContactEntity> items = await ref.watch(contactsProvider.future);
  final String query = ref.watch(searchContactQueryStateProvider).trim().toLowerCase();
  final ContactsSortType sortType = ref.watch(searchContactSortStateProvider);

  return FilteredContactsState(
    contacts: items
        .where((ContactEntity element) {
          if (query.length > 1) {
            return element.fullname.contains(RegExp(query, caseSensitive: false));
          }

          return true;
        })
        .sorted(_sort(sortType))
        .toList(growable: false),
  );
}

class FilteredContactsState with EquatableMixin {
  const FilteredContactsState({required this.contacts});

  final List<ContactEntity> contacts;

  @override
  List<Object> get props => <Object>[contacts];
}

@riverpod
class SearchContactQueryState extends _$SearchContactQueryState with StateNotifierMixin {
  @override
  String build() => '';

  bool isSearching() => state.length > 1;
}

@riverpod
class SearchContactSortState extends _$SearchContactSortState with StateNotifierMixin {
  @override
  ContactsSortType build() => ContactsSortType.names;
}

Comparator<ContactEntity> _sort(ContactsSortType sortType) {
  switch (sortType) {
    case ContactsSortType.jobs:
      return (ContactEntity a, ContactEntity b) => b.totalJobs.compareTo(a.totalJobs);
    case ContactsSortType.names:
      return (ContactEntity a, ContactEntity b) => a.fullname.compareTo(b.fullname);
    case ContactsSortType.completed:
      return (ContactEntity a, ContactEntity b) => (b.totalJobs - b.pendingJobs).compareTo(a.totalJobs - a.pendingJobs);
    case ContactsSortType.pending:
      return (ContactEntity a, ContactEntity b) => b.pendingJobs.compareTo(a.pendingJobs);
    case ContactsSortType.recent:
      return (ContactEntity a, ContactEntity b) => b.createdAt.compareTo(a.createdAt);
    case ContactsSortType.reset:
      return (ContactEntity a, ContactEntity b) => a.id.compareTo(b.id);
  }
}
