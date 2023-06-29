import 'dart:async';

import 'package:tailor_made/domain.dart';

import '../../network/firebase.dart';

class StatsImpl extends Stats {
  StatsImpl({
    required this.firebase,
    required this.isDev,
  });

  final Firebase firebase;
  final bool isDev;

  @override
  Stream<StatsEntity> fetch(String userId) {
    return firebase.db.doc('stats/$userId').snapshots().map((MapDocumentSnapshot snapshot) {
      final DynamicMap data = snapshot.data()!;
      return StatsEntity(
        jobs: _deriveStatsItemEntity(data['jobs'] as Map<String, dynamic>),
        contacts: _deriveStatsItemEntity(data['contacts'] as Map<String, dynamic>),
        gallery: _deriveStatsItemEntity(data['gallery'] as Map<String, dynamic>),
        payments: _deriveStatsItemEntity(data['payments'] as Map<String, dynamic>),
      );
    });
  }
}

StatsItemEntity _deriveStatsItemEntity(DynamicMap data) {
  return StatsItemEntity(
    total: (data['total'] as num?)?.toDouble() ?? 0.0,
    pending: (data['pending'] as num?)?.toDouble() ?? 0.0,
    completed: (data['completed'] as num?)?.toDouble() ?? 0.0,
  );
}
