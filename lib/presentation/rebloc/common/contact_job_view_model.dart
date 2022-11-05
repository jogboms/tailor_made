import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

// ignore: must_be_immutable
class ContactJobViewModel extends Equatable {
  ContactJobViewModel(AppState state)
      : _contacts = state.contacts.contacts,
        _jobs = state.jobs.jobs,
        account = state.account.account;

  ContactModel? get selectedContact {
    if (contactID != null) {
      try {
        return contacts!.firstWhere((_) => _.id == contactID);
      } catch (e) {
        //
      }
    }
    return null;
  }

  JobModel? get selectedJob {
    if (jobID != null) {
      try {
        return jobs!.firstWhere((_) => _.id == jobID);
      } catch (e) {
        //
      }
    }
    return null;
  }

  String? contactID;
  String? jobID;
  final AccountModel? account;

  final List<JobModel>? _jobs;

  List<JobModel>? get jobs => _jobs;

  final List<ContactModel>? _contacts;

  List<ContactModel>? get contacts => _contacts;

  @override
  List<Object?> get props => <Object?>[account, jobs, contacts];
}
