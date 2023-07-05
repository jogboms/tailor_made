import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import 'account_provider.dart';
import 'registry_provider.dart';

part 'measurements_provider.g.dart';

@Riverpod(dependencies: <Object>[registry, account])
Stream<MeasurementsState> measurements(MeasurementsRef ref) async* {
  final AccountEntity account = await ref.watch(accountProvider.future);

  final Measures measures = ref.read(registryProvider).get<Measures>();

  yield* measures.fetchAll(account.uid).map((List<MeasureEntity> items) {
    if (items.isEmpty) {
      measures.update(BaseMeasureEntity.defaults, account.uid).ignore();
    }

    return MeasurementsState(
      userId: account.uid,
      measures: items.sorted((MeasureEntity a, MeasureEntity b) => a.group.compareTo(b.group)),
      grouped: groupBy(items, (_) => _.group),
    );
  });
}

class MeasurementsState with EquatableMixin {
  const MeasurementsState({
    required this.userId,
    required this.measures,
    required this.grouped,
  });

  final String userId;
  final List<MeasureEntity> measures;
  final Map<MeasureGroup, List<MeasureEntity>> grouped;

  @override
  List<Object> get props => <Object>[userId, measures, grouped];
}
