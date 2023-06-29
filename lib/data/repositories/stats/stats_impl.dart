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
  Stream<StatsModel> fetch(String? userId) {
    return firebase.db
        .doc('stats/$userId')
        .snapshots()
        .map((MapDocumentSnapshot snapshot) => StatsModel.fromJson(snapshot.data()!));
  }
}
