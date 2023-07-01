import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:tailor_made/domain.dart';
import 'package:tailor_made/presentation/rebloc.dart';

class JobsViewModel extends Equatable {
  JobsViewModel(AppState state, {this.jobID})
      : _model = state.jobs.jobs ?? <JobEntity>[],
        _contacts = state.contacts.contacts ?? <ContactEntity>[],
        userId = state.account.account!.uid,
        isLoading = false;

  List<JobEntity> get tasks {
    final List<JobEntity> tasks = _model.where((JobEntity job) => !job.isComplete).toList();
    return tasks..sort((JobEntity a, JobEntity b) => a.dueAt.compareTo(b.dueAt));
  }

  JobEntity? get selected => _model.firstWhereOrNull((_) => _.id == jobID);

  ContactEntity? get selectedContact => _contacts.firstWhereOrNull((_) => _.id == selected?.contactID);

  final String? jobID;

  final String userId;

  final List<ContactEntity> _contacts;

  final List<JobEntity> _model;

  final bool isLoading;

  @override
  List<Object?> get props => <Object?>[_model, userId, _contacts, isLoading];
}
