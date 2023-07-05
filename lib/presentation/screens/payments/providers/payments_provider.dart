import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';

part 'payments_provider.g.dart';

@Riverpod(dependencies: <Object>[registry, account])
Stream<List<PaymentEntity>> payments(PaymentsRef ref) async* {
  final AccountEntity account = await ref.watch(accountProvider.future);

  yield* ref.read(registryProvider).get<Payments>().fetchAll(account.uid);
}
