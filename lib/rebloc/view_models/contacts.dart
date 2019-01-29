import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/rebloc/actions/contacts.dart';
import 'package:tailor_made/rebloc/states/contacts.dart';
import 'package:tailor_made/rebloc/states/main.dart';

class ContactsViewModel extends Equatable {
  ContactsViewModel(AppState state)
      : model = state.contacts.contacts,
        searchResults = state.contacts.searchResults,
        isSearching = state.contacts.isSearching,
        hasSortFn = state.contacts.hasSortFn,
        measures = state.measures.grouped,
        jobs = state.jobs.jobs,
        sortFn = state.contacts.sortFn,
        isLoading = state.contacts.status == ContactsStatus.loading,
        hasError = state.contacts.status == ContactsStatus.failure,
        error = state.contacts.error,
        super(<AppState>[state]);

  List<ContactModel> get contacts => isSearching ? searchResults : model;

  // TODO
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
  final List<ContactModel> searchResults;
  final Map<String, List<MeasureModel>> measures;
  final List<JobModel> jobs;
  final List<ContactModel> model;
  final bool hasSortFn;
  final SortType sortFn;
  final bool isLoading;
  final bool hasError;
  final bool isSearching;
  final dynamic error;

  // void setSortFn(SortType type) => store.dispatch(SortContacts(payload: type));

  // void search(String term) => store.dispatch(SearchContactEvent(payload: term));

  // void cancelSearch() => store.dispatch(CancelSearchContactEvent());
}
