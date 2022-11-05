import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/jobs/sort_type.dart';

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
    final List<JobModel> tasks = model!.where((JobModel job) => !job.isComplete!).toList();
    return tasks..sort((JobModel a, JobModel b) => a.dueAt!.compareTo(b.dueAt!));
  }

  JobModel? get selected {
    if (jobID != null) {
      try {
        return model!.firstWhere((_) => _.id == jobID);
      } catch (e) {
        //
      }
    }
    return null;
  }

  ContactModel? get selectedContact {
    if (selected != null) {
      try {
        return contacts!.firstWhere((_) => _.id == selected!.contactID);
      } catch (e) {
        //
      }
    }
    return null;
  }

  List<JobModel> get selectedJobs {
    if (selected != null) {
      try {
        return jobs!.where((JobModel job) => job.contactID == selected!.id).toList();
      } catch (e) {
        //
      }
    }
    return <JobModel>[];
  }

  String? jobID;

  final String userId;

  final BuiltList<ContactModel>? _contacts;

  List<ContactModel>? get contacts => _contacts?.toList();

  final BuiltList<JobModel>? _searchResults;

  List<JobModel>? get searchResults => _searchResults?.toList();

  final Map<String, List<MeasureModel>>? measures;

  final BuiltList<JobModel>? _model;

  List<JobModel>? get model => _model?.toList();

  final bool hasSortFn;
  final SortType sortFn;
  final bool isLoading;
  final bool isSearching;
  final bool hasError;
  final dynamic error;

  @override
  List<Object?> get props =>
      <Object?>[model, hasSortFn, sortFn, userId, isSearching, searchResults, contacts, isLoading, hasError, error];
}
