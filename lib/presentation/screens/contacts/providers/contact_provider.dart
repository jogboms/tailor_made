import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';

part 'contact_provider.g.dart';

@Riverpod(dependencies: <Object>[account, registry])
ContactProvider contact(ContactRef ref) {
  return ContactProvider(
    fetchAccount: () => ref.read(accountProvider.future),
    contacts: ref.read(registryProvider).get(),
  );
}

class ContactProvider {
  const ContactProvider({
    required AsyncValueGetter<AccountEntity> fetchAccount,
    required Contacts contacts,
  })  : _fetchAccount = fetchAccount,
        _contacts = contacts;

  final AsyncValueGetter<AccountEntity> _fetchAccount;
  final Contacts _contacts;

  Future<ContactEntity> create({
    required CreateContactData contact,
  }) async {
    final String userId = (await _fetchAccount()).uid;
    return _contacts.create(userId, contact);
  }

  Future<void> update({
    required ReferenceEntity reference,
    required CreateContactData contact,
  }) async {
    final String userId = (await _fetchAccount()).uid;
    await _contacts.update(
      userId,
      reference: reference,
      fullname: contact.fullname,
      phone: contact.phone,
      location: contact.location,
      imageUrl: contact.imageUrl,
      measurements: contact.measurements,
    );
  }

  Future<void> modifyMeasurements({
    required ReferenceEntity reference,
    required Map<String, double> measurements,
  }) async {
    final String userId = (await _fetchAccount()).uid;
    await _contacts.update(
      userId,
      reference: reference,
      measurements: measurements,
    );
  }
}
