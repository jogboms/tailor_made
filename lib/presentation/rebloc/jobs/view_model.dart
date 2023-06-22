import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class JobsViewModel extends Equatable {
  JobsViewModel(AppState state, {this.jobID})
      : _model = state.jobs.jobs ?? <JobEntity>[],
        _contacts = state.contacts.contacts ?? <ContactEntity>[],
        _searchResults = state.jobs.searchResults ?? <JobEntity>[],
        isSearching = state.jobs.isSearching,
        hasSortFn = state.jobs.hasSortFn,
        measures = state.measures.grouped ?? <String, List<MeasureModel>>{},
        userId = state.account.account!.uid,
        sortFn = state.jobs.sortFn,
        isLoading = state.jobs.status == StateStatus.loading,
        hasError = state.jobs.status == StateStatus.failure,
        error = state.jobs.error;

  List<JobEntity> get jobs => isSearching ? searchResults : model;

  List<JobEntity> get tasks {
    final List<JobEntity> tasks = model.where((JobEntity job) => !job.isComplete).toList();
    return tasks..sort((JobEntity a, JobEntity b) => a.dueAt.compareTo(b.dueAt));
  }

  JobEntity? get selected => model.firstWhereOrNull((_) => _.id == jobID);

  ContactEntity? get selectedContact => contacts.firstWhereOrNull((_) => _.id == selected?.contactID);

  List<JobEntity> get selectedJobs => jobs.where((JobEntity job) => job.contactID == selected?.id).toList();

  final String? jobID;

  final String userId;

  final List<ContactEntity> _contacts;

  List<ContactEntity> get contacts => _contacts;

  final List<JobEntity> _searchResults;

  List<JobEntity> get searchResults => _searchResults;

  final Map<String, List<MeasureModel>> measures;

  final List<JobEntity> _model;

  List<JobEntity> get model => _model;

  final bool hasSortFn;
  final JobsSortType sortFn;
  final bool isLoading;
  final bool isSearching;
  final bool hasError;
  final String? error;

  @override
  List<Object?> get props =>
      <Object?>[model, hasSortFn, sortFn, userId, isSearching, searchResults, contacts, isLoading, hasError, error];
}
