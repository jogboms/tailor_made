import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import 'account_provider.dart';
import 'registry_provider.dart';

part 'contacts_provider.g.dart';

@Riverpod(dependencies: <Object>[registry, account])
Stream<List<ContactEntity>> contacts(ContactsRef ref) async* {
  final AccountEntity account = await ref.watch(accountProvider.future);

  yield* ref.read(registryProvider).get<Contacts>().fetchAll(account.uid);
}
