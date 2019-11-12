import 'package:built_collection/built_collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/models/account.dart';
import 'package:tailor_made/models/contact.dart';
import 'package:tailor_made/models/job.dart';
import 'package:tailor_made/rebloc/app_state.dart';

// ignore: must_be_immutable
class ContactJobViewModel extends Equatable {
  ContactJobViewModel(AppState state)
      : _contacts = state.contacts.contacts,
        _jobs = state.jobs.jobs,
        account = state.account.account;

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

  final BuiltList _jobs;

  List<JobModel> get jobs => _jobs?.toList();

  final BuiltList _contacts;

  List<ContactModel> get contacts => _contacts?.toList();

  @override
  List<Object> get props => [account, jobs, contacts];
}
