import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/rebloc/app_state.dart';

class ContactJobViewModel extends Equatable {
  ContactJobViewModel(AppState state)
      : contacts = state.contacts.contacts,
        account = state.account.account,
        jobs = state.jobs.jobs,
        super(<AppState>[state]);

  ContactModel get selectedContact {
    if (contactID != null) {
      try {
        return contacts.firstWhere((_) => _.id == contactID);
      } catch (e) {
        //
      }
    }
    return null;
  }

  JobModel get selectedJob {
    if (jobID != null) {
      try {
        return jobs.firstWhere((_) => _.id == jobID);
      } catch (e) {
        //
      }
    }
    return null;
  }

  String contactID;
  String jobID;
  final AccountModel account;
  final List<JobModel> jobs;
  final List<ContactModel> contacts;
}
