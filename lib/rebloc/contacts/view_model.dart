import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/app_state.dart';
import 'package:tailor_made/rebloc/contacts/sort_type.dart';

// ignore: must_be_immutable
class ContactsViewModel extends Equatable {
  ContactsViewModel(AppState state)
      : _model = state.contacts.contacts,
        _searchResults = state.contacts.searchResults,
        isSearching = state.contacts.isSearching,
        hasSortFn = state.contacts.hasSortFn,
        measures = state.measures.grouped,
        userId = state.account.account.uid,
        _jobs = state.jobs.jobs,
        sortFn = state.contacts.sortFn,
        isLoading = state.contacts.status == StateStatus.loading,
        hasError = state.contacts.status == StateStatus.failure,
        error = state.contacts.error;

  List<ContactModel> get contacts => isSearching ? searchResults : model;

  Map<String, List<MeasureModel>> get measuresGrouped => measures;

  ContactModel get selected {
    if (contactID != null) {
      try {
        return model.firstWhere((_) => _.id == contactID);
      } catch (e) {
        //
      }
    }
    return null;
  }

  List<JobModel> get selectedJobs {
    if (selected != null) {
      try {
        return jobs.where((job) => job.contactID == selected.id).toList();
      } catch (e) {
        //
      }
    }
    return [];
  }

  String contactID;

  final String userId;

  final BuiltList _searchResults;

  List<ContactModel> get searchResults => _searchResults?.toList();

  final Map<String, List<MeasureModel>> measures;

  final BuiltList _jobs;

  List<JobModel> get jobs => _jobs?.toList();

  final BuiltList _model;

  List<ContactModel> get model => _model?.toList();

  final bool hasSortFn;
  final SortType sortFn;
  final bool isLoading;
  final bool hasError;
  final bool isSearching;
  final dynamic error;

  @override
  List<Object> get props =>
      [model, hasSortFn, sortFn, userId, isSearching, jobs, contacts, searchResults, isLoading, hasError, error];
}
