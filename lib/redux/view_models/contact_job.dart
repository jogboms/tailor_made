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
      try {
        return store.state.contacts.contacts.firstWhere(
          (_) => _.id == contactID,
        );
      } catch (e) {
        //
      }
    }
    return null;
  }

  JobModel get selectedJob {
    if (jobID != null) {
      try {
        return store.state.jobs.jobs.firstWhere(
          (_) => _.id == jobID,
        );
      } catch (e) {
        //
      }
    }
    return null;
  }
}
