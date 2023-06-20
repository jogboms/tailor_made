import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class ContactJobViewModel extends Equatable {
  ContactJobViewModel(
    AppState state, {
    required this.contactID,
    required this.jobID,
  })  : _contacts = state.contacts.contacts,
        _jobs = state.jobs.jobs,
        account = state.account.account;

  ContactModel? get selectedContact => _contacts?.firstWhereOrNull((_) => _.id == contactID);

  JobModel? get selectedJob => _jobs?.firstWhereOrNull((_) => _.id == jobID);

  final String contactID;
  final String jobID;
  final AccountEntity? account;

  final List<JobModel>? _jobs;

  final List<ContactModel>? _contacts;

  @override
  List<Object?> get props => <Object?>[account, _jobs, _contacts];
}
