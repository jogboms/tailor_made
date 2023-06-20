import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class ContactsViewModel extends Equatable {
  ContactsViewModel(AppState state, {this.contactID})
      : _model = state.contacts.contacts,
        _searchResults = state.contacts.searchResults,
        isSearching = state.contacts.isSearching,
        hasSortFn = state.contacts.hasSortFn,
        measures = state.measures.grouped,
        userId = state.account.account!.uid,
        _jobs = state.jobs.jobs,
        sortFn = state.contacts.sortFn,
        isLoading = state.contacts.status == StateStatus.loading,
        hasError = state.contacts.status == StateStatus.failure,
        error = state.contacts.error;

  List<ContactModel>? get contacts => isSearching ? searchResults : model;

  Map<String, List<MeasureModel>>? get measuresGrouped => measures;

  ContactModel? get selected => model?.firstWhereOrNull((_) => _.id == contactID);

  List<JobModel> get selectedJobs =>
      jobs?.where((JobModel job) => job.contactID == selected?.id).toList() ?? <JobModel>[];

  final String? contactID;

  final String userId;

  final List<ContactModel>? _searchResults;

  List<ContactModel>? get searchResults => _searchResults;

  final Map<String, List<MeasureModel>>? measures;

  final List<JobModel>? _jobs;

  List<JobModel>? get jobs => _jobs;

  final List<ContactModel>? _model;

  List<ContactModel>? get model => _model;

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
