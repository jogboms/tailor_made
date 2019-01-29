import 'package:redux/redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/models/measure.dart';
import 'package:tailor_made/redux/actions/contacts.dart';
import 'package:tailor_made/redux/states/contacts.dart';
import 'package:tailor_made/rebloc/states/main.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class ContactsViewModel extends ViewModel {
  String contactID;

  ContactsViewModel(Store<AppState> store) : super(store);

  ContactsState get _state => store.state.contacts;

  List<ContactModel> get contacts {
    return isSearching ? _state.searchResults : _state.contacts;
  }

  Map<String, List<MeasureModel>> get measuresGrouped =>
      store.state.measures.grouped;

  ContactModel get selected {
    if (contactID != null) {
      try {
        return _state.contacts.firstWhere(
          (_) => _.id == contactID,
        );
      } catch (e) {
        //
      }
    }
    return null;
  }

  List<JobModel> get selectedJobs {
    if (selected != null) {
      try {
        return store.state.jobs.jobs
            .where((job) => job.contactID == selected.id)
            .toList();
      } catch (e) {
        //
      }
    }
    return [];
  }

  bool get isLoading => _state.status == ContactsStatus.loading;

  bool get isSuccess => _state.status == ContactsStatus.success;

  bool get isFailure => _state.status == ContactsStatus.failure;

  SortType get sortFn => _state.sortFn;

  bool get hasSortFn => _state.hasSortFn;

  bool get isSearching => _state.isSearching;

  void setSortFn(SortType type) => store.dispatch(SortContacts(payload: type));

  void search(String term) => store.dispatch(SearchContactEvent(payload: term));

  void cancelSearch() => store.dispatch(CancelSearchContactEvent());
}
