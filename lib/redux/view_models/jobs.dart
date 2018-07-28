import 'package:redux/redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/redux/actions/jobs.dart';
import 'package:tailor_made/redux/states/jobs.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class JobsViewModel extends ViewModel {
  String jobID;

  JobsViewModel(Store<ReduxState> store) : super(store);

  JobsState get _state => store.state.jobs;

  List<JobModel> get jobs {
    return isSearching ? _state.searchResults : store.state.jobs.jobs;
  }

  List<JobModel> get tasks {
    final tasks =
        store.state.jobs.jobs.where((job) => !job.isComplete).toList();
    return tasks..sort((a, b) => a.dueAt.compareTo(b.dueAt));
  }

  List<ContactModel> get contacts {
    return store.state.contacts.contacts;
  }

  JobModel get selected {
    if (jobID != null) {
      try {
        return _state.jobs.firstWhere(
          (_) => _.id == jobID,
        );
      } catch (e) {
        //
      }
    }
    return null;
  }

  ContactModel get selectedContact {
    if (selected != null) {
      try {
        return contacts.firstWhere((_) => _.id == selected.contactID);
      } catch (e) {
        //
      }
    }
    return null;
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
