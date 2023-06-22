import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class ContactsViewModel extends Equatable {
  ContactsViewModel(AppState state, {this.contactID})
      : _model = state.contacts.contacts ?? <ContactEntity>[],
        _searchResults = state.contacts.searchResults ?? <ContactEntity>[],
        isSearching = state.contacts.isSearching,
        hasSortFn = state.contacts.hasSortFn,
        measuresGrouped = state.measures.grouped ?? <String, List<MeasureModel>>{},
        userId = state.account.account!.uid,
        _jobs = state.jobs.jobs ?? <JobEntity>[],
        sortFn = state.contacts.sortFn,
        isLoading = state.contacts.status == StateStatus.loading,
        hasError = state.contacts.status == StateStatus.failure,
        error = state.contacts.error;

  List<ContactEntity> get contacts => isSearching ? searchResults : model;

  final Map<String, List<MeasureModel>> measuresGrouped;

  ContactEntity? get selected => model.firstWhereOrNull((_) => _.id == contactID);

  List<JobEntity> get selectedJobs => jobs.where((JobEntity job) => job.contactID == selected?.id).toList();

  final String? contactID;

  final String userId;

  final List<ContactEntity> _searchResults;

  List<ContactEntity> get searchResults => _searchResults;

  final List<JobEntity> _jobs;

  List<JobEntity> get jobs => _jobs;

  final List<ContactEntity> _model;

  List<ContactEntity> get model => _model;

  final bool hasSortFn;
  final ContactsSortType sortFn;
  final bool isLoading;
  final bool hasError;
  final bool isSearching;
  final dynamic error;

  @override
  List<Object?> get props => <Object?>[
        model,
        hasSortFn,
        sortFn,
        userId,
        isSearching,
        jobs,
        contacts,
        searchResults,
        isLoading,
        hasError,
        error
      ];
}
