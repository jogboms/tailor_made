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

  List<JobModel> get jobs {
    final jobs = this.store.state.jobs.jobs;
    if (contact != null) {
      return jobs.where((_) => _.contactID == contact.id).toList();
    }
    return jobs;
  }

  List<ContactModel> get contacts {
    return this.store.state.contacts.contacts;
  }

  filterByContact(ContactModel contact) {
    contact = contact;
  }

  toggleCompleteJob(JobModel job) {
    return this.store.dispatch(ToggleCompleteJob(payload: job));
  }

  bool get isLoading => this.store.state.jobs.status == JobsStatus.loading;

  bool get isSuccess => this.store.state.jobs.status == JobsStatus.success;

  bool get isFailure => this.store.state.jobs.status == JobsStatus.failure;
}
