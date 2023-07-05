import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tailor_made/domain.dart';

import '../../../state.dart';

part 'measurement_provider.g.dart';

@Riverpod(dependencies: <Object>[account, registry])
MeasurementProvider measurement(MeasurementRef ref) {
  return MeasurementProvider(
    fetchAccount: () => ref.read(accountProvider.future),
    measures: ref.read(registryProvider).get(),
  );
}

class MeasurementProvider {
  @visibleForTesting
  const MeasurementProvider({
    required AsyncValueGetter<AccountEntity> fetchAccount,
    required Measures measures,
  })  : _fetchAccount = fetchAccount,
        _measures = measures;

  final AsyncValueGetter<AccountEntity> _fetchAccount;
  final Measures _measures;

  Future<bool> create({
    required List<BaseMeasureEntity> measures,
    required MeasureGroup group,
    required String unit,
  }) async {
    final String userId = (await _fetchAccount()).uid;
    return _measures.create(measures, userId, group: group, unit: unit);
  }

  Future<void> updateName({
    required ReferenceEntity reference,
    required String name,
  }) async {
    await _measures.updateOne(reference, name: name);
  }

  Future<void> deleteItem({
    required ReferenceEntity reference,
  }) async {
    await _measures.deleteOne(reference);
  }

  Future<void> deleteGroup({
    required List<MeasureEntity> measures,
  }) async {
    final String userId = (await _fetchAccount()).uid;
    await _measures.deleteGroup(measures, userId);
  }
}
