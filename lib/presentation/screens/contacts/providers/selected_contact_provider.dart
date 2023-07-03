import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';

part 'selected_contact_provider.g.dart';

@Riverpod(dependencies: <Object>[jobs, contacts, measurements])
Future<ContactState> selectedContact(SelectedContactRef ref, String id) async {
  final ContactEntity contact = await ref.watch(
    contactsProvider.selectAsync((_) => _.firstWhere((_) => _.id == id)),
  );
  final List<JobEntity> jobs = await ref.watch(
    jobsProvider.selectAsync((_) => _.where((_) => _.contactID == id).toList()),
  );
  final MeasurementsState measurements = await ref.watch(measurementsProvider.future);

  return ContactState(
    contact: contact,
    jobs: jobs,
    measurements: measurements.grouped,
  );
}

class ContactState with EquatableMixin {
  const ContactState({
    required this.contact,
    required this.jobs,
    required this.measurements,
  });

  final ContactEntity contact;
  final List<JobEntity> jobs;
  final Map<MeasureGroup, List<MeasureEntity>> measurements;

  @override
  List<Object?> get props => <Object?>[contact, jobs, measurements];
}
