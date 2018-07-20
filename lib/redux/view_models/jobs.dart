import 'package:redux/redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/redux/actions/jobs.dart';
import 'package:tailor_made/redux/states/jobs.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class JobsViewModel extends ViewModel {
  ContactModel contact;

  JobsViewModel(Store<ReduxState> store) : super(store);

  JobsState get _state => store.state.jobs;

  List<JobModel> get jobs {
    final jobs = store.state.jobs.jobs;
    if (contact != null) {
      return jobs.where((_) => _.contactID == contact.id).toList();
    }
    return isSearching ? _state.searchResults : jobs;
  }

  List<ContactModel> get contacts {
    return store.state.contacts.contacts;
  }

  void filterByContact(ContactModel contact) {
    contact = contact;
  }

  void toggleCompleteJob(JobModel job) {
    return store.dispatch(ToggleCompleteJob(payload: job));
  }

  bool get isLoading => store.state.jobs.status == JobsStatus.loading;

  bool get isSuccess => store.state.jobs.status == JobsStatus.success;

  bool get isFailure => store.state.jobs.status == JobsStatus.failure;

  SortType get sortFn => _state.sortFn;

  bool get hasSortFn => _state.hasSortFn;

  bool get isSearching => _state.isSearching;

  void setSortFn(SortType type) => store.dispatch(SortJobs(payload: type));

  void search(String term) => store.dispatch(SearchJobEvent(payload: term));

  void cancelSearch() => store.dispatch(CancelSearchJobEvent());
}
