import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';

part 'selected_job_provider.g.dart';

@Riverpod(dependencies: <Object>[account, jobs, contacts])
Future<JobState> selectedJob(SelectedJobRef ref, String id) async {
  final AccountEntity account = await ref.watch(accountProvider.future);
  final List<JobEntity> jobs = await ref.watch(jobsProvider.future);

  final JobEntity job = jobs.firstWhere((_) => _.id == id);
  final ContactEntity contact = await ref.watch(
    contactsProvider.selectAsync((_) => _.firstWhere((_) => _.id == job.contactID)),
  );

  return JobState(
    job: job,
    contact: contact,
    userId: account.uid,
  );
}

class JobState with EquatableMixin {
  const JobState({
    required this.job,
    required this.contact,
    required this.userId,
  });

  final JobEntity job;
  final ContactEntity contact;
  final String userId;

  @override
  List<Object> get props => <Object>[job, contact, userId];
}
