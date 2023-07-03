import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import 'account_provider.dart';
import 'contacts_provider.dart';
import 'jobs_provider.dart';

part 'selected_contact_job_provider.g.dart';

@Riverpod(dependencies: <Object>[account, contacts, jobs])
Future<ContactJobState> selectedContactJob(
  SelectedContactJobRef ref, {
  required String contactId,
  required String jobId,
}) async {
  final AccountEntity account = await ref.watch(accountProvider.future);
  final ContactEntity contact = await ref.watch(
    contactsProvider.selectAsync((_) => _.firstWhere((_) => _.id == contactId)),
  );
  final JobEntity job = await ref.watch(
    jobsProvider.selectAsync((_) => _.firstWhere((_) => _.id == jobId)),
  );

  return ContactJobState(
    selectedContact: contact,
    selectedJob: job,
    account: account,
  );
}

class ContactJobState {
  const ContactJobState({
    required this.selectedContact,
    required this.selectedJob,
    required this.account,
  });

  final ContactEntity selectedContact;
  final JobEntity selectedJob;
  final AccountEntity account;
}
