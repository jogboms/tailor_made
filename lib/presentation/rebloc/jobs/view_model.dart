import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

// ignore: must_be_immutable
class JobsViewModel extends Equatable {
  JobsViewModel(AppState state)
      : _model = state.jobs.jobs,
        _contacts = state.contacts.contacts,
        _searchResults = state.jobs.searchResults,
        isSearching = state.jobs.isSearching,
        hasSortFn = state.jobs.hasSortFn,
        measures = state.measures.grouped,
        userId = state.account.account!.uid,
        sortFn = state.jobs.sortFn,
        isLoading = state.jobs.status == StateStatus.loading,
        hasError = state.jobs.status == StateStatus.failure,
        error = state.jobs.error;

  List<JobModel>? get jobs => isSearching ? searchResults : model;

  List<JobModel> get tasks {
    final List<JobModel> tasks = model!.where((JobModel job) => !job.isComplete).toList();
    return tasks..sort((JobModel a, JobModel b) => a.dueAt.compareTo(b.dueAt));
  }

  JobModel? get selected {
    if (jobID != null) {
      return model!.firstWhereOrNull((_) => _.id == jobID);
    }
    return null;
  }

  ContactModel? get selectedContact {
    if (selected != null) {
      return contacts!.firstWhereOrNull((_) => _.id == selected!.contactID);
    }
    return null;
  }

  List<JobModel> get selectedJobs {
    if (selected != null) {
      return jobs!.where((JobModel job) => job.contactID == selected!.id).toList();
    }
    return <JobModel>[];
  }

  String? jobID;

  final String userId;

  final List<ContactModel>? _contacts;

  List<ContactModel>? get contacts => _contacts;

  final List<JobModel>? _searchResults;

  List<JobModel>? get searchResults => _searchResults;

  final Map<String, List<MeasureModel>>? measures;

  final List<JobModel>? _model;

  List<JobModel>? get model => _model;

  final bool hasSortFn;
  final JobsSortType sortFn;
  final bool isLoading;
  final bool isSearching;
  final bool hasError;
  final dynamic error;

  @override
  List<Object?> get props =>
      <Object?>[model, hasSortFn, sortFn, userId, isSearching, searchResults, contacts, isLoading, hasError, error];
}
