import 'package:redux/redux.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/redux/states/main.dart';
import 'package:tailor_made/redux/view_models/main.dart';

class ContactJobViewModel extends ViewModel {
  String contactID;
  String jobID;

  ContactJobViewModel(Store<ReduxState> store) : super(store);

  ContactModel get selectedContact {
    if (contactID != null) {
      return this.store.state.contacts.contacts.firstWhere(
            (_) => _.id == contactID,
          );
    }
    return null;
  }

  JobModel get selectedJob {
    if (jobID != null) {
      return this.store.state.jobs.jobs.firstWhere(
            (_) => _.id == jobID,
          );
    }
    return null;
  }
}
