import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import 'account_provider.dart';
import 'registry_provider.dart';

part 'stats_provider.g.dart';

@Riverpod(dependencies: <Object>[registry, account])
Stream<StatsEntity> stats(StatsRef ref) async* {
  final AccountEntity account = await ref.watch(accountProvider.future);

  yield* ref.read(registryProvider).get<Stats>().fetch(account.uid);
}
